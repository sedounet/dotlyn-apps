import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../models/gameplay_type.dart';
import '../models/ship.dart';
import '../models/resource.dart';
import '../providers/profile_provider.dart';
import '../providers/session_provider.dart';
import '../providers/gameplay_type_provider.dart';
import '../providers/ship_provider.dart';
import '../providers/resource_provider.dart';
import '../services/database_service.dart';

class LoopsScreen extends StatelessWidget {
  const LoopsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Boucles (workflows)', style: Theme.of(context).textTheme.headlineSmall),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (kDebugMode)
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _resetDatabase(context),
                          tooltip: 'Reset DB (debug)',
                        ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () => _showAddLoopDialog(context),
                        tooltip: 'Ajouter une boucle',
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(),
              if (provider.profiles.isEmpty)
                const Center(child: Text('Aucune boucle. Appuyez sur + pour en créer une.'))
              else
                ...provider.profiles.map((profile) => ListTile(
                      leading: const Icon(Icons.repeat),
                      title: Text(profile.name),
                      subtitle: Text(profile.description.isNotEmpty
                          ? profile.description
                          : 'Étapes: ${profile.steps.join(', ')}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showEditLoopDialog(context, profile),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await provider.deleteProfile(profile.id);
                            },
                          ),
                        ],
                      ),
                    )),
            ],
          ),
        );
      },
    );
  }

  Future<void> _resetDatabase(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text('Supprimer toutes les données et recréer la BDD ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await DatabaseService().resetDatabase();
      if (context.mounted) {
        Provider.of<ProfileProvider>(context, listen: false).loadProfiles();
        Provider.of<SessionProvider>(context, listen: false).loadSessions();
        Provider.of<GameplayTypeProvider>(context, listen: false).loadTypes();
        Provider.of<ShipProvider>(context, listen: false).loadShips();
        Provider.of<ResourceProvider>(context, listen: false).loadResources();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Base de données réinitialisée')),
        );
      }
    }
  }

  void _showAddLoopDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddLoopScreen()),
    );
  }

  void _showEditLoopDialog(BuildContext context, Profile profile) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddLoopScreen(profileToEdit: profile)),
    );
  }
}

class AddLoopScreen extends StatefulWidget {
  final Profile? profileToEdit;

  const AddLoopScreen({super.key, this.profileToEdit});

  @override
  State<AddLoopScreen> createState() => _AddLoopScreenState();
}

class _AddLoopScreenState extends State<AddLoopScreen> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<TextEditingController> _stepControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int? _selectedGameplayTypeId;
  int? _selectedShipId;
  final List<Map<String, dynamic>> _selectedResources = []; // {resourceId}

  @override
  void initState() {
    super.initState();
    if (widget.profileToEdit != null) {
      _nameController.text = widget.profileToEdit!.name;
      _descriptionController.text = widget.profileToEdit!.description;
      _selectedGameplayTypeId = widget.profileToEdit!.gameplayTypeId;
      _selectedShipId = widget.profileToEdit!.shipId;

      // Charger les étapes
      _stepControllers.clear();
      for (var step in widget.profileToEdit!.steps) {
        _stepControllers.add(TextEditingController(text: step));
      }

      // Charger les ressources
      _loadProfileResources();
    }
  }

  Future<void> _loadProfileResources() async {
    if (widget.profileToEdit != null) {
      final resources = await DatabaseService().getProfileResources(widget.profileToEdit!.id);
      setState(() {
        _selectedResources.addAll(resources.map((r) => {'resourceId': r.resourceId}));
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    for (var controller in _stepControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addStep() {
    setState(() {
      _stepControllers.add(TextEditingController());
    });
  }

  void _removeStep(int index) {
    if (_stepControllers.length > 1) {
      setState(() {
        _stepControllers[index].dispose();
        _stepControllers.removeAt(index);
      });
    }
  }

  Future<void> _showAddGameplayTypeDialog() async {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau type de gameplay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom (ex: Salvage)')),
            const SizedBox(height: 8),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && context.mounted) {
                final provider = Provider.of<GameplayTypeProvider>(context, listen: false);
                final id = await provider.addType(GameplayType(
                  id: 0,
                  name: nameController.text,
                  description: descController.text,
                  loopIds: [],
                ));
                setState(() {
                  _selectedGameplayTypeId = id;
                });
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditGameplayTypeDialog(GameplayType type) async {
    final nameController = TextEditingController(text: type.name);
    final descController = TextEditingController(text: type.description);

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le type de gameplay'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 8),
            TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && context.mounted) {
                final provider = Provider.of<GameplayTypeProvider>(context, listen: false);
                await provider.updateType(GameplayType(
                  id: type.id,
                  name: nameController.text,
                  description: descController.text,
                  loopIds: type.loopIds,
                ));
                setState(() {});
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteGameplayType(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce type de gameplay ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<GameplayTypeProvider>(context, listen: false);
      await provider.deleteType(id);
      setState(() {
        _selectedGameplayTypeId = null;
      });
    }
  }

  Future<void> _showAddShipDialog() async {
    final nameController = TextEditingController();
    final typeController = TextEditingController();

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouveau vaisseau'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom (ex: Vulture)')),
            const SizedBox(height: 8),
            TextField(
                controller: typeController,
                decoration: const InputDecoration(labelText: 'Type (ex: Salvage)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && context.mounted) {
                final provider = Provider.of<ShipProvider>(context, listen: false);
                final id = await provider.addShip(Ship(
                  id: 0,
                  name: nameController.text,
                  type: typeController.text,
                  notes: '',
                ));
                setState(() {
                  _selectedShipId = id;
                });
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditShipDialog(Ship ship) async {
    final nameController = TextEditingController(text: ship.name);
    final typeController = TextEditingController(text: ship.type);

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Modifier le vaisseau'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController, decoration: const InputDecoration(labelText: 'Nom')),
            const SizedBox(height: 8),
            TextField(
                controller: typeController, decoration: const InputDecoration(labelText: 'Type')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty && context.mounted) {
                final provider = Provider.of<ShipProvider>(context, listen: false);
                await provider.updateShip(Ship(
                  id: ship.id,
                  name: nameController.text,
                  type: typeController.text,
                  notes: ship.notes,
                ));
                setState(() {});
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Modifier'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteShip(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Voulez-vous vraiment supprimer ce vaisseau ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final provider = Provider.of<ShipProvider>(context, listen: false);
      await provider.deleteShip(id);
      setState(() {
        _selectedShipId = null;
      });
    }
  }

  Future<void> _showAddResourceDialog() async {
    int? selectedResourceId;

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ajouter une ressource'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Consumer<ResourceProvider>(
              builder: (context, provider, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(labelText: 'Ressource'),
                            items: provider.resources
                                .map((r) => DropdownMenuItem(
                                    value: r.id, child: Text('${r.name} (${r.unit})')))
                                .toList(),
                            onChanged: (value) => setState(() => selectedResourceId = value),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _showCreateResourceDialog(),
                          tooltip: 'Créer ressource',
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              if (selectedResourceId != null) {
                setState(() {
                  _selectedResources.add({
                    'resourceId': selectedResourceId,
                  });
                });
                Navigator.pop(context, true);
              }
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateResourceDialog() async {
    final nameController = TextEditingController();
    final unitController = TextEditingController(text: 'SCU');

    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nouvelle ressource'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nom (ex: Ruble Salvage)')),
            const SizedBox(height: 8),
            TextField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'Unité (ex: SCU, kg)')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Annuler')),
          TextButton(
            onPressed: () async {
              if (nameController.text.isNotEmpty &&
                  unitController.text.isNotEmpty &&
                  context.mounted) {
                final provider = Provider.of<ResourceProvider>(context, listen: false);
                await provider.addResource(Resource(
                  id: 0,
                  name: nameController.text,
                  unit: unitController.text,
                ));
                if (context.mounted) Navigator.pop(context, true);
              }
            },
            child: const Text('Créer'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveBoucle() async {
    final steps = _stepControllers.map((c) => c.text).where((s) => s.isNotEmpty).toList();
    if (_nameController.text.isEmpty || steps.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nom et au moins une étape requis')),
      );
      return;
    }

    final profile = Profile(
      id: 0,
      name: _nameController.text,
      description: _descriptionController.text,
      steps: steps,
      gameplayTypeId: _selectedGameplayTypeId,
      shipId: _selectedShipId,
    );

    final provider = Provider.of<ProfileProvider>(context, listen: false);
    int? profileId;

    // Check if we're editing or creating
    if (widget.profileToEdit != null) {
      // Update existing profile
      final updatedProfile = Profile(
        id: widget.profileToEdit!.id,
        name: _nameController.text,
        description: _descriptionController.text,
        steps: steps,
        gameplayTypeId: _selectedGameplayTypeId,
        shipId: _selectedShipId,
      );
      await provider.updateProfile(updatedProfile);
      profileId = widget.profileToEdit!.id;
    } else {
      // Create new profile
      profileId = await provider.addProfile(profile);
    }

    // Save resources if any
    if (_selectedResources.isNotEmpty && profileId != null) {
      await DatabaseService().setProfileResources(profileId, _selectedResources);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(widget.profileToEdit != null ? 'Boucle modifiée !' : 'Boucle créée !')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.profileToEdit != null ? 'Modifier la boucle' : 'Nouvelle boucle'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de la boucle',
                hintText: 'ex: Salvage Daymar épaves',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'ex: Salvage solo avec Vulture en exploration libre',
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            Text('Type de gameplay', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Consumer<GameplayTypeProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Gameplay'),
                        value: _selectedGameplayTypeId,
                        items: provider.types
                            .map((type) => DropdownMenuItem(value: type.id, child: Text(type.name)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedGameplayTypeId = value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _showAddGameplayTypeDialog,
                      tooltip: 'Créer un type',
                    ),
                    if (_selectedGameplayTypeId != null) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditGameplayTypeDialog(
                            provider.types.firstWhere((t) => t.id == _selectedGameplayTypeId)),
                        tooltip: 'Modifier',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteGameplayType(_selectedGameplayTypeId!),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Vaisseau', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Consumer<ShipProvider>(
              builder: (context, provider, _) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<int>(
                        decoration: const InputDecoration(labelText: 'Vaisseau'),
                        value: _selectedShipId,
                        items: provider.ships
                            .map((ship) => DropdownMenuItem(value: ship.id, child: Text(ship.name)))
                            .toList(),
                        onChanged: (value) => setState(() => _selectedShipId = value),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _showAddShipDialog,
                      tooltip: 'Créer un vaisseau',
                    ),
                    if (_selectedShipId != null) ...[
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditShipDialog(
                            provider.ships.firstWhere((s) => s.id == _selectedShipId)),
                        tooltip: 'Modifier',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteShip(_selectedShipId!),
                        tooltip: 'Supprimer',
                      ),
                    ],
                  ],
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ressources attendues', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddResourceDialog,
                  tooltip: 'Ajouter une ressource',
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_selectedResources.isEmpty)
              const Text('Aucune ressource configurée',
                  style: TextStyle(fontStyle: FontStyle.italic))
            else
              Consumer<ResourceProvider>(
                builder: (context, provider, _) {
                  return Column(
                    children: _selectedResources.map((res) {
                      final resource = provider.resources.firstWhere(
                        (r) => r.id == res['resourceId'],
                        orElse: () => Resource(id: 0, name: 'Unknown', unit: ''),
                      );
                      return ListTile(
                        dense: true,
                        title: Text('${resource.name} (${resource.unit})'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () {
                            setState(() {
                              _selectedResources.remove(res);
                            });
                          },
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Étapes', style: Theme.of(context).textTheme.titleMedium),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addStep,
                  tooltip: 'Ajouter une étape',
                ),
              ],
            ),
            const SizedBox(height: 8),
            ..._stepControllers.asMap().entries.map((entry) {
              final index = entry.key;
              final controller = entry.value;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          labelText: 'Étape ${index + 1}',
                          hintText: index == 0 ? 'ex: Décollage' : null,
                        ),
                      ),
                    ),
                    if (_stepControllers.length > 1)
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _removeStep(index),
                      ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveBoucle,
                child: Text(
                    widget.profileToEdit != null ? 'Modifier la boucle' : 'Enregistrer la boucle'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
