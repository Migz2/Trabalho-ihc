import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:honey/core/services/pet_decay_service.dart';
import 'package:honey/features/focus/presentation/providers/user_provider.dart';
import 'package:honey/features/pet/data/repositories/pet_repository_impl.dart';
import 'package:honey/features/pet/domain/entities/pet_action_result_entity.dart';
import 'package:honey/features/pet/domain/entities/pet_entity.dart';
import 'package:honey/features/pet/domain/repositories/pet_repository.dart';
import 'package:honey/features/pet/domain/usecases/apply_focus_reward_usecase.dart';
import 'package:honey/features/pet/domain/usecases/bathe_pet_usecase.dart';
import 'package:honey/features/pet/domain/usecases/feed_pet_usecase.dart';
import 'package:honey/features/pet/domain/usecases/pet_pet_usecase.dart';

// Provider instances
final petRepositoryProvider = Provider<PetRepository>(
  (ref) => PetRepositoryImpl(),
);

final petDecayServiceProvider = Provider<PetDecayService>(
  (ref) => PetDecayService(),
);

final feedPetUseCaseProvider = Provider<FeedPetUseCase>(
  (ref) => FeedPetUseCase(),
);

final bathePetUseCaseProvider = Provider<BathePetUseCase>(
  (ref) => BathePetUseCase(),
);

final petPetUseCaseProvider = Provider<PetPetUseCase>(
  (ref) => PetPetUseCase(),
);

final applyFocusRewardUseCaseProvider = Provider<ApplyFocusRewardUseCase>(
  (ref) => ApplyFocusRewardUseCase(),
);

// Main pet provider
final petProvider = AsyncNotifierProvider<PetNotifier, PetEntity>(
  () => PetNotifier(),
);

class PetNotifier extends AsyncNotifier<PetEntity> {
  late PetRepository _repository;
  late PetDecayService _decayService;
  Timer? _decayTimer;
  Timer? _periodicCheckTimer;

  @override
  Future<PetEntity> build() async {
    // Store references to providers
    _repository = ref.watch(petRepositoryProvider);
    _decayService = ref.watch(petDecayServiceProvider);

    // Load pet from repository
    var pet = await _repository.getOrCreatePet();

    // Apply accumulated decay
    if (_decayService.needsDecayCheck(pet)) {
      pet = _decayService.applyDecay(pet);
      await _repository.savePet(pet);
    }

    // Start periodic decay check (every 60 seconds)
    _startDecayTimer();

    // When app is disposed, cancel timers
    ref.onDispose(() {
      _decayTimer?.cancel();
      _periodicCheckTimer?.cancel();
    });

    return pet;
  }

  /// Feed the pet
  Future<PetActionResultEntity> feed() async {
    final pet = state.value;
    if (pet == null) return PetActionResultEntity(
      success: false,
      message: 'Erro ao carregar Mel',
      coinsSpent: 0,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: 0,
      newMood: pet?.computedMood ?? throw Exception('Pet not loaded'),
    );

    final userCoins = ref.watch(userProvider).value?.coins ?? 0;
    final feedUseCase = ref.watch(feedPetUseCaseProvider);

    final result = feedUseCase.feed(pet: pet, userCoins: userCoins);

    if (result.success) {
      // Deduct coins from user
      ref.read(userProvider.notifier).spendCoins(result.coinsSpent);

      // Update pet
      final updatedPet = pet.copyWith(
        hunger: (pet.hunger + result.hungerDelta).clamp(0.0, 100.0),
        happiness: (pet.happiness + result.happinessDelta).clamp(0.0, 100.0),
        lastInteraction: DateTime.now(),
      );

      await _repository.savePet(updatedPet);
      state = AsyncData(updatedPet);
    }

    return result;
  }

  /// Bathe the pet
  Future<PetActionResultEntity> bathe() async {
    final pet = state.value;
    if (pet == null) return PetActionResultEntity(
      success: false,
      message: 'Erro ao carregar Mel',
      coinsSpent: 0,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: 0,
      newMood: pet?.computedMood ?? throw Exception('Pet not loaded'),
    );

    final userCoins = ref.watch(userProvider).value?.coins ?? 0;
    final batheUseCase = ref.watch(bathePetUseCaseProvider);

    final result = batheUseCase.bathe(pet: pet, userCoins: userCoins);

    if (result.success) {
      // Deduct coins from user
      ref.read(userProvider.notifier).spendCoins(result.coinsSpent);

      // Update pet
      final updatedPet = pet.copyWith(
        hygiene: (pet.hygiene + result.hygieneDelta).clamp(0.0, 100.0),
        happiness: (pet.happiness + result.happinessDelta).clamp(0.0, 100.0),
        lastInteraction: DateTime.now(),
      );

      await _repository.savePet(updatedPet);
      state = AsyncData(updatedPet);
    }

    return result;
  }

  /// Give love to the pet
  Future<PetActionResultEntity> giveLove() async {
    final pet = state.value;
    if (pet == null) return PetActionResultEntity(
      success: false,
      message: 'Erro ao carregar Mel',
      coinsSpent: 0,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: 0,
      newMood: pet?.computedMood ?? throw Exception('Pet not loaded'),
    );

    final userCoins = ref.watch(userProvider).value?.coins ?? 0;
    final petUseCase = ref.watch(petPetUseCaseProvider);

    final result = petUseCase.giveLove(pet: pet, userCoins: userCoins);

    if (result.success) {
      // Deduct coins from user
      ref.read(userProvider.notifier).spendCoins(result.coinsSpent);

      // Update pet
      final updatedPet = pet.copyWith(
        happiness: (pet.happiness + result.happinessDelta).clamp(0.0, 100.0),
        lastInteraction: DateTime.now(),
      );

      await _repository.savePet(updatedPet);
      state = AsyncData(updatedPet);
    }

    return result;
  }

  /// Apply focus session reward to pet
  Future<PetActionResultEntity> applyFocusReward() async {
    final pet = state.value;
    if (pet == null) return PetActionResultEntity(
      success: false,
      message: 'Erro ao carregar Mel',
      coinsSpent: 0,
      hungerDelta: 0,
      hygieneDelta: 0,
      happinessDelta: 0,
      newMood: pet?.computedMood ?? throw Exception('Pet not loaded'),
    );

    final rewardUseCase = ref.watch(applyFocusRewardUseCaseProvider);
    final result = rewardUseCase.applyFocusReward(pet: pet);

    // Update pet
    final updatedPet = pet.copyWith(
      happiness: (pet.happiness + result.happinessDelta).clamp(0.0, 100.0),
      energy: (pet.energy + 10.0).clamp(0.0, 100.0), // energy from usecase
      experience: pet.experience + 20,
      level: result.levelUpOccurred ? pet.level + 1 : pet.level,
      lastInteraction: DateTime.now(),
    );

    await _repository.savePet(updatedPet);
    state = AsyncData(updatedPet);

    return result;
  }

  /// Start periodic decay timer
  void _startDecayTimer() {
    // Check and apply decay every 60 seconds
    _periodicCheckTimer = Timer.periodic(
      const Duration(seconds: 60),
      (_) async {
        final pet = state.value;
        if (pet != null && _decayService.needsDecayCheck(pet)) {
          final decayedPet = _decayService.applyDecay(pet);
          await _repository.savePet(decayedPet);
          state = AsyncData(decayedPet);
        }
      },
    );
  }
}
