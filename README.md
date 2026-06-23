# Honey — App de Produtividade com Timer Pomodoro & Pet Virtual

Um app Flutter que estimula a produtividade através de sessões de foco
(técnica Pomodoro) enquanto o usuário cuida de um pet virtual — quanto mais
ciclos de foco completados, mais feliz e desenvolvido o pet fica.

Projeto desenvolvido para a disciplina de **IHC (Interação Humano-Computador)**.

## Sobre

Honey combina a técnica **Pomodoro** com um sistema de **pet virtual**. O
usuário ganha moedas completando ciclos de foco, e usa essas moedas para
alimentar, cuidar e equipar acessórios no seu pet através de uma loja
integrada.

### Funcionalidades

-  **Timer Pomodoro** com duração de foco/pausas customizável, incluindo
  ajuste rápido (+/- 5 min) direto na tela de Foco enquanto o timer está parado
-  **Pet virtual** com fome, higiene, felicidade e energia, nome
  personalizável (no onboarding ou depois em Configurações), e fallback
  desenhado 100% em Flutter caso a arte do pet não esteja disponível
-  **Loja** com 7 itens (acessórios, brinquedos, fundos) que dão bônus de
  felicidade/moedas/redução de decaimento ao serem equipados
-  **Estatísticas** com streak atual/recorde, horas totais focadas, gráfico
  semanal e conquistas desbloqueáveis
-  **Configurações** completas: duração de foco/pausas, tema claro/escuro,
  som ambiente, bloqueio de apps (parcial — ver limitações), notificações,
  perfil e renomear o pet
-  **Modo escuro** com paleta quente baseada em tons de mel
-  **Notificações locais** para lembretes de sessão
-  Overlays de celebração ao completar ciclos, subir de nível e desbloquear
  conquistas

---

##  Stack Tecnológica

### Framework & Linguagem
- **Flutter** 3.16+ com Null Safety
- **Dart** 3.0+

### Gerenciamento de Estado
- **Riverpod** (`flutter_riverpod` + `riverpod_annotation`/`riverpod_generator`)

### Navegação
- **GoRouter** (rotas declarativas + `ShellRoute` para a bottom navigation)

### Persistência
- **Hive** (armazenamento local rápido, offline-first)

### UI & Design
- **Google Fonts** (Playfair Display + DM Sans)
- **Material Design 3** com tema próprio (claro/escuro)
- **flutter_animate** para animações e transições

### Outros
- **fl_chart** — gráfico semanal nas Estatísticas
- **audioplayers** — efeitos sonoros
- **flutter_local_notifications** — lembretes
- **permission_handler** / **app_usage** — bloqueio de apps (parcial)

---

##  Como executar

### Pré-requisitos
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.16 ou mais recente
- Dart 3.0+ (instalado junto com o Flutter)
- Um editor (VS Code, Android Studio ou IntelliJ com plugin Flutter)
- Para rodar em celular Android: Android Studio (ou só as platform-tools/ADB)
- Para rodar em celular iOS: macOS + Xcode

Verifique se o ambiente está pronto com:

```bash
flutter doctor
```

### 1. Clonar e instalar dependências

```bash
git clone https://github.com/Migz2/Trabalho-ihc.git
cd Trabalho-ihc
flutter pub get
```

### 2. Ver quais dispositivos estão disponíveis

```bash
flutter devices
```

Esse comando lista tudo que o Flutter já reconhece: o próprio PC (Linux,
Windows ou macOS como "desktop"), emuladores abertos, navegadores e
celulares conectados.

### 3. Rodar no PC (desktop)

O projeto já tem suporte a desktop habilitado (pastas `linux/`, `windows/` e
`macos/` no repositório). Para rodar direto no computador, sem emulador nem
celular:

```bash
# Linux
flutter run -d linux

# Windows
flutter run -d windows

# macOS
flutter run -d macos
```

Se só houver um dispositivo conectado (por exemplo, só o desktop), basta
`flutter run` sem o `-d`.

> No Linux, certifique-se de ter as dependências de desenvolvimento GTK
> instaladas (`flutter doctor` avisa se faltar algo).

### 4. Rodar no navegador (web)

```bash
flutter run -d chrome
```

> Algumas funcionalidades dependentes de plugins nativos (notificações
> locais, bloqueio de apps) têm comportamento limitado ou nulo na web.

### 5. Rodar em um celular Android conectado

**Via cabo USB:**

1. No celular, ative o **Modo Desenvolvedor**: Configurações → Sobre o
   telefone → toque 7x em "Número da versão (build)".
2. Em Configurações → Opções do desenvolvedor, ative **Depuração USB**.
3. Conecte o celular ao PC via cabo USB e autorize a depuração no popup que
   aparece na tela do celular.
4. Confirme que o aparelho foi reconhecido:
   ```bash
   flutter devices
   ```
5. Rode o app apontando para o ID do dispositivo listado:
   ```bash
   flutter run -d <device_id>
   ```

**Via Wi-Fi (depuração sem fio, Android 11+):**

1. Ative as Opções do desenvolvedor e a **Depuração sem fio** no celular.
2. No celular, toque em "Parear dispositivo com código de pareamento" e
   anote o código/IP:porta exibidos.
3. No PC:
   ```bash
   adb pair <ip>:<porta-de-pareamento>
   # digite o código de 6 dígitos mostrado no celular
   adb connect <ip>:<porta-de-conexão>
   flutter devices
   flutter run -d <device_id>
   ```

### 6. Rodar em um iPhone conectado (requer macOS + Xcode)

1. Conecte o iPhone via cabo e confie no computador quando solicitado.
2. Abra `ios/Runner.xcworkspace` no Xcode pelo menos uma vez para configurar
   o time de assinatura (Signing & Capabilities).
3. ```bash
   flutter devices
   flutter run -d <device_id>
   ```

### 7. Gerar um instalável (APK) para instalar manualmente no Android

Útil quando não dá para deixar o cabo conectado ou para enviar o app a
outra pessoa testar:

```bash
flutter build apk --debug
# gera build/app/outputs/flutter-apk/app-debug.apk
```

Transfira o `.apk` para o celular (cabo, e-mail, Drive, etc.) e instale
manualmente — pode ser necessário permitir "instalar de fontes
desconhecidas" nas configurações do Android.

Para uma build de release real (assinada), veja a seção de **Limitações
conhecidas / próximos passos** no [`FINAL_REPORT.md`](FINAL_REPORT.md) — o
`applicationId` ainda é o de exemplo (`com.example.honey_app`) e não há
`keystore` de assinatura configurado.

### Comandos úteis de desenvolvimento

```bash
# Verificar qualidade do código (deve dar 0 erros)
flutter analyze

# Formatar código
dart format lib/

# Rodar os testes
flutter test

# Limpar build cache (útil se algo não compilar após mudar de branch)
flutter clean && flutter pub get
```

---

##  Estrutura do Projeto

```
lib/
├── main.dart             # bootstrap: Hive, notificações, orientação
├── app.dart              # MaterialApp.router + tema
│
├── core/                 # infraestrutura compartilhada
│   ├── constants/        # chaves Hive, constantes globais
│   ├── theme/            # cores, tipografia, espaçamento, raio
│   ├── services/         # Hive, timer, decay do pet, notificações, DI
│   ├── errors/            # exceptions tipadas
│   ├── utils/             # helpers (datas, animação)
│   └── extensions/        # context_extensions (cores tema-aware), etc.
│
├── shared/                # compartilhado entre features
│   ├── widgets/           # HoneyButton, CoinDisplay, EmptyStateWidget, HomeShell...
│   └── navigation/         # GoRouter (rotas + shell)
│
├── features/               # cada feature em Clean Architecture
│   ├── focus/              # timer Pomodoro, sessões, usuário (moedas/streak)
│   ├── pet/                # Mel: estado, decay, ações, loja-bônus
│   ├── shop/                # catálogo, compra, equipar
│   ├── statistics/          # streak, horas, conquistas, gráfico
│   ├── settings/             # preferências, bloqueio de apps, perfil
│   └── onboarding/           # 3 telas de introdução + nome do pet
│
└── assets/                   # imagens, animações
```

Cada feature segue `domain/` (entities, usecases, contratos de repositório)
→ `data/` (models Hive + implementação dos repositórios) → `presentation/`
(providers Riverpod + páginas + widgets). Detalhes de arquitetura, schema
Hive e fluxo de dados completo estão em [`FINAL_REPORT.md`](FINAL_REPORT.md).

---

##  Design System

### Paleta de cores
- **Primária:** `#C17F3E` (dourado mel) / `#D4924E` (modo escuro)
- **Fundo:** `#FAF7F2` (creme claro) / `#1C1410` (escuro quente)
- **Destaque:** `#F4A942` (laranja suave)

### Tipografia
- **Display/headlines:** Playfair Display
- **Corpo de texto:** DM Sans

### Espaçamento
`4px, 8px, 16px, 24px, 32px, 48px`

### Raio de borda
`8px, 12px, 16px, 24px, 100px (circular)`

---

## 🔄 Navegação

**Fluxo raiz:**
1. App verifica em Hive se o onboarding já foi concluído.
2. Se não → `/onboarding` (3 telas, incluindo escolha do nome do pet).
3. Se sim → `/focus` (aba padrão).

**Bottom navigation (5 abas):**
-  **Foco** (`/focus`) — timer Pomodoro + preview do pet
-  **Pet** (`/pet`) — tela completa do pet (atributos, ações)
-  **Loja** (`/shop`) — catálogo de itens
-  **Histórico** (`/history`) — estatísticas e conquistas
-  **Ajustes** (`/settings`) — preferências e perfil

---

##  Status atual

O app está **funcionalmente completo**: todas as features descritas acima
estão implementadas e integradas (timer, pet, loja, estatísticas,
configurações e onboarding). `flutter analyze` roda com **0 erros** e
`flutter test` passa.

Para o histórico detalhado de cada fase de desenvolvimento (o que foi feito
e quando), veja [`PROGRESS.md`](PROGRESS.md).

### Limitações conhecidas

- **Bloqueio de apps é parcial** — a listagem de apps instalados e a
  detecção do app em primeiro plano ainda são placeholders; a tela existe e
  salva preferências, mas não bloqueia de fato.
- **`applicationId` de exemplo** (`com.example.honey_app`) — trocar antes de
  publicar.
- **Importante ao adicionar assets em subpastas**: declarar `assets/images/`
  no `pubspec.yaml` não inclui subpastas automaticamente — cada subpasta
  (ex: `assets/images/pet/`) precisa ser listada explicitamente, ou os
  arquivos não entram no bundle (mesmo existindo em disco e compilando sem
  erro). Já corrigido para a pasta do pet.
- **Sincronização parcial de duração do timer**: ajustar a duração pelos
  botões +/- da tela de Foco atualiza o timer imediatamente; ajustar pelos
  sliders de Configurações só é refletido na próxima vez que o timer for
  reiniciado naquela fase.

Lista completa e mais detalhada em [`FINAL_REPORT.md`](FINAL_REPORT.md).

---

##  Requisitos de Dispositivo

- **Android 5.0+** (API 21)
- **iOS 11.0+**
- Mínimo de 50MB de armazenamento livre
- Também roda como app de **desktop** (Linux/Windows/macOS) e **web**, com
  algumas funcionalidades nativas limitadas nessas plataformas

---

##  Testes

```bash
flutter test
```

---

##  Licença

MIT License — veja o arquivo LICENSE.

##  Contribuidores

- **Ana Caroline Fachini** — Desenvolvedor (Projeto IHC)
- **Miguel De almeida Silva** — Desenvolvedor (Projeto IHC)
- **Stéffany Fabris Boebel** — Desenvolvedor (Projeto IHC)

##  Suporte

Para problemas ou sugestões, abra uma issue no GitHub.

---


