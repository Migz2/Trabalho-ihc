# Honey — Relatório Final (Fase de Refinamento)

Este documento resume o estado do app Honey ao final da fase de polish, a
arquitetura, o esquema de persistência Hive, o que falta para publicar em
produção e as limitações conhecidas.

## 1. Arquitetura

Clean Architecture por feature, com Riverpod como camada de estado:

```
lib/
├── main.dart                 # bootstrap: Hive, notificações, orientação
├── app.dart                  # MaterialApp.router + tema + status bar reativa
├── core/
│   ├── constants/            # chaves Hive, constantes globais
│   ├── errors/                # exceptions tipadas
│   ├── extensions/           # context_extensions (cores/tema dark-safe)
│   ├── services/             # Hive, notificações, bloqueio de apps, sons,
│   │                           timer, decay do pet, DI (service_providers)
│   ├── theme/                 # AppColors, AppTypography, AppSpacing, AppRadius
│   └── utils/                 # animation_constants (durations/curves padrão)
├── shared/
│   ├── navigation/             # GoRouter (app_router.dart) + rotas + shell
│   └── widgets/                # HoneyButton, HoneyCard, CoinDisplay,
│                                  EmptyStateWidget, HoneyShimmer, HomeShell
└── features/
    ├── focus/        # timer Pomodoro, sessões, usuário (coins/streak)
    ├── pet/           # Mel: estado, decay, ações (alimentar/banhar/carinho)
    ├── shop/          # catálogo de itens, compra, equipar, bônus
    ├── statistics/    # streak, horas, conquistas, gráfico semanal
    ├── settings/       # preferências, bloqueio de apps, perfil
    └── onboarding/      # 3 telas de introdução
```

Cada feature segue `domain/` (entities, usecases, repositories abstratas) →
`data/` (models Hive + implementação dos repositórios) → `presentation/`
(providers Riverpod + páginas + widgets).

### Fluxo de dados típico (ex.: completar um ciclo de foco)

`TimerService` (singleton, persiste em Hive) emite `phaseCompleteStream` →
`TimerNotifier` (em `timer_provider.dart`) escuta o evento e:
1. credita moedas (`userProvider.addCoins`)
2. aplica recompensa ao pet (`petProvider.applyFocusReward`) — se isso causar
   level-up, dispara `petLevelUpEventProvider`
3. persiste uma `FocusSessionModel` no Hive e chama
   `statisticsProvider.refresh()`, que recalcula streak/horas/conquistas e
   expõe `newlyUnlockedAchievementsProvider` se algo foi desbloqueado
4. `FocusPage` escuta `lastCycleCoinsEarnedProvider`/`petLevelUpEventProvider`
   e exibe os overlays de celebração; `HomeShell` (sempre montado) escuta
   `newlyUnlockedAchievementsProvider` e mostra o banner de conquista
   independente da aba ativa.

## 2. Esquema Hive (typeId)

| typeId | Classe                  | Tipo            | Box                  |
|-------:|--------------------------|-----------------|----------------------|
| 0      | `PetModel`               | model           | `petBox`             |
| 1      | `OnboardingModel`        | model           | —                    |
| 2      | `FocusSessionModel`      | model           | `sessionBox`         |
| 3      | `TimerStateModel`        | model           | `sessionBox`         |
| 4      | `UserModel`              | model           | `userBox`            |
| 5      | `PetMoodAdapter`         | enum (`PetMood`)| —                    |
| 6      | `ItemCategoryAdapter`    | enum            | —                    |
| 7      | `ItemRarityAdapter`      | enum            | —                    |
| 8      | `AchievementModel`       | model           | `achievementsBox`    |
| 9      | `ShopItemModel`          | model           | `shopBox`            |
| 10     | `StatisticsModel`        | model           | `statisticsBox`      |
| 11     | `SettingsModel`          | model           | `settingsBox`        |
| 12     | `AppThemeModeAdapter`    | enum            | —                    |
| 13     | `AmbientSoundAdapter`    | enum            | —                    |
| 14     | `BlockIntensityAdapter`  | enum            | —                    |
| 15     | `AchievementIdAdapter`   | enum            | —                    |

Todos os adapters são registrados em `core/services/hive_service.dart` antes
de qualquer box ser aberta. **Importante:** ao adicionar um novo model/enum
persistido, use o próximo typeId livre (16+) — nunca reaproveite um valor já
atribuído, mesmo de um model removido, sob risco de corromper dados já
salvos no dispositivo do usuário.

## 3. O que foi feito nesta fase

- Sistema de animação padronizado (`AnimationDurations`/`AnimationCurves`) e
  aplicado em timer, navegação, cards, botões e overlays.
- Auditoria dark-mode: remoção de cores hardcoded (`Colors.white`,
  `Color(0xFF...)`) substituídas por `context.surface`/`AppColors.dark*` em
  Focus, Pet, Shop e Onboarding.
- `RepaintBoundary` no arco do timer, no card do pet e no `CoinDisplay`;
  `select()` granular em vez de `.watch()` cru nos headers de Focus/Pet.
- Três overlays de celebração (`CycleCompleteOverlay`,
  `AchievementUnlockOverlay`, `LevelUpOverlay`), com triggers reais ligados
  ao fluxo do timer e ao provider de estatísticas.
- `EmptyStateWidget` e `HoneyShimmer` (shimmer próprio, sem dependência
  externa) usados em Histórico, Loja e Pet.
- Micro-interações: tap-scale + haptics em `HoneyButton`/`ActionButton`,
  pulso no `CoinDisplay`, haptics em sliders/switches/radio/checkbox das
  Configurações, pulso de equip/unequip nos itens da loja.
- Onboarding redesenhado com ilustrações 100% Flutter (sem Lottie/assets
  externos): círculos decorativos + ícone (tela 1), emoji pulsante + moedas
  subindo (tela 2), avatar com corações flutuando (tela 3), CTA "Começar 🍯"
  com entrada animada.
- **Feature de Estatísticas reconstruída de fato**: o provider antigo era um
  stub que computava dados e os descartava (`// for now we don't push a UI
  model`) e a tela era um placeholder estático. Agora: `StatisticsNotifier`
  expõe `StatisticsEntity` real, `CalculateStreakUseCase` novo calcula streak
  atual/recorde a partir das sessões salvas, `CheckAchievementsUseCase` foi
  estendido para cobrir streaks/horário noturno/madrugada, e a página tem
  grid de métricas, gráfico semanal (`fl_chart`) e lista de conquistas
  desbloqueadas/bloqueadas.
- `timer_provider.dart` agora **persiste cada sessão de foco completada**
  (antes, sessões nunca eram salvas — Estatísticas ficaria vazia para
  sempre).
- Loja: tocar num item já possuído agora alterna equipar/desequipar (antes
  sempre abria o diálogo de compra, sem caminho para equipar pela UI).
- `ProfilePage` agora mostra nível/moedas/streak reais (eram strings fixas
  `'1'`/`'0'`/`'0'`) e salvar o nome sincroniza `settingsProvider` **e**
  `userProvider` (antes só o primeiro era atualizado, então o nome exibido
  no Focus nunca mudava).
- Lint: `analysis_options.yaml` continha ~30 regras removidas/inexistentes
  no Dart 3 e uma lista de estilo extremamente extensa herdada de um
  template antigo, gerando 886 issues. Foi simplificado para
  `flutter_lints` + um conjunto pequeno e intencional de regras extras.
  Resultado: **0 erros, 0 warnings**, 153 infos remanescentes (estilo, não
  bugs).
- Release prep: `android:label` corrigido para "Honey", `SystemChrome`
  (orientação portrait + status bar reativa ao tema) em `main.dart`/`app.dart`,
  dependência `hive` declarada explicitamente, `lottie` (não usado) removido.
- Build de verificação: `flutter build apk --debug` concluído com sucesso
  após todas as mudanças (`build/app/outputs/flutter-apk/app-debug.apk`).

## 4. Próximos passos para produção

- [ ] **`applicationId`** em `android/app/build.gradle.kts` ainda é
  `com.example.honey_app` — trocar para o domínio real antes de gerar uma
  build de release/assinada.
- [ ] **Ícone do app**: hoje usa o ícone padrão do template Flutter. Gerar
  com `flutter_launcher_icons` a partir de uma arte real do Honey.
- [ ] **Splash screen**: configurar `flutter_native_splash` (ou
  `android:windowSplashScreen` no Android 12+) com a identidade visual.
- [ ] **Assets do pet**: `pet_assets.dart` referencia
  `assets/images/pet/mel_happy.png` etc., mas a pasta só tem um `.gitkeep` —
  essas imagens nunca foram entregues. `PetDisplayWidget` e o onboarding
  (tela 3) hoje usam emoji/formas como substituto. Assim que a arte
  existir, basta trocar `Text('🐻')` pelos `Image.asset(...)` já referenciados
  em `pet_assets.dart`.
- [ ] **Build assinada**: configurar `key.properties` +
  `signingConfigs` em `android/app/build.gradle.kts` para release.
- [ ] **Detecção real de app em primeiro plano** para o bloqueio de apps
  (ver limitação abaixo).
- [ ] **Lista real de apps instalados** no dispositivo (ver limitação
  abaixo).

## 5. Limitações conhecidas

- **Bloqueio de apps é parcial.** `AppBlockingService.getInstalledApps()`
  retorna sempre `[]` e `startMonitoring()` não detecta de fato o app em
  primeiro plano — ambos são placeholders pré-existentes. Implementar de
  verdade exige um plugin de usage-stats (ex. `app_usage`, já é dependência
  mas não está conectado a esse fluxo) ou `device_apps` para listar apps
  instalados.
- **`applicationId` de exemplo** (`com.example.honey_app`) — ver seção 4.
- **Sem assets reais do pet** — ver seção 4. Desde a sessão de refinamento de
  UX/UI, o `errorBuilder` do `Image.asset` em `PetDisplayWidget` usa um
  `PetFallbackPainter` (`CustomPainter` que desenha um cachorrinho simples,
  variando expressão por humor) em vez de mostrar um ícone de imagem
  quebrada; o preview pequeno na tela de Foco usa um fallback de emoji 🐾.
  Quando a arte real existir, basta os `Image.asset(...)` em
  `pet_assets.dart` resolverem normalmente e os fallbacks nunca mais serão
  acionados — nenhuma mudança de código extra é necessária.
- **Sincronização parcial entre timer e Configurações**: os novos botões
  +/- na tela de Foco (`TimerService.setPhaseDuration()`) atualizam a
  duração da fase atual **e** o `remainingSeconds` exibido imediatamente,
  quando o timer está parado (`isIdle`). Porém, alterar a duração pelos
  *sliders* da tela de Configurações ainda só chama
  `settingsProvider.notifier.updateFocusDuration()` (não chama
  `TimerService.setPhaseDuration()`), então essa via continua sem refletir
  no timer já carregado até ele ser reiniciado. Resolver completamente
  exigiria ou unificar as duas vias de ajuste, ou fazer o `TimerNotifier`
  observar `settingsProvider` — não feito aqui para não tocar mais código
  do que o solicitado na sessão de correções cirúrgicas.
- **`avoid_print`**: o projeto usa `print()` para logging em vários
  services (em vez de um logger estruturado). Mantido como está — trocar
  por um logger é uma melhoria de observabilidade, não um bug, e tocaria
  ~28 pontos do código sem relação direta com esta fase.
- **153 infos de lint remanescentes** (majoritariamente
  `prefer_const_constructors`, `deprecated_member_use` de `withOpacity`, e
  `use_super_parameters`) — nenhum é erro ou bug; é um varrido mecânico
  grande o suficiente para merecer uma passada própria, não incluída aqui
  para não inflar o diff desta fase com centenas de mudanças triviais.
