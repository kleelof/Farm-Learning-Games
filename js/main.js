const app = document.querySelector("#app");
const gameShell = document.querySelector("#game");
const controls = document.querySelector("#game-controls");
const homeButton = document.querySelector("#home-button");
const soundButton = document.querySelector("#sound-button");
const fullscreenButton = document.querySelector("#fullscreen-button");
const themeAudio = document.querySelector("#theme-audio");
const garyAudio = document.querySelector("#gary-audio");
const happyAudio = document.querySelector("#happy-audio");
const unhappyAudio = document.querySelector("#unhappy-audio");
const grabDuckAudio = new Audio("originalswfs/farmgameswf/sounds/7_grabDuck.mp3");
const correctDuckAudio = new Audio("originalswfs/farmgameswf/sounds/6_correctDuck.mp3");

let config;
let muted = false;
let currentMusic = "theme";
let currentGameKey = null;
let cleanupCurrent = () => {};

const pageByGame = { professor: 1, suzy: 2, gary: 4, ducks: 5 };

const gameInfo = {
  professor: {
    title: "Professor Chicken",
    animal: "🐔",
    art: "assets/images/professor-menu.png",
    summary: "Answer farmyard trivia and earn your academic feathers.",
    instructions: "Choose the correct answer to each question. After you answer, the correct choice will remain on the blackboard. Your final rank depends on how many questions you answer correctly.",
    start: startProfessorChicken
  },
  suzy: {
    title: "Suzy Sow’s Spelling",
    animal: "🐷",
    art: "assets/images/suzy-menu.png",
    summary: "Remember each word, then find it hidden in the letter grid.",
    instructions: "Study the word, choose Continue, then select its letters in order from the grid. Letters must touch horizontally, vertically, or diagonally. Finding a word earns a point and adds time. Show Word pauses the timer.",
    start: startSuzySow
  },
  gary: {
    title: "Gary Goat’s Grammar Grabber",
    animal: "🐐",
    art: "assets/images/gary-menu.png",
    summary: "Catch nouns, verbs, or adjectives without eating the wrong words.",
    instructions: "Choose a grammar group. Move Gary with the mouse. When a falling word reaches Gary, click to eat it. Correct words earn points. Three wrong words end the game.",
    start: showGaryGroupSelector
  },
  ducks: {
    title: "Digit Ducks",
    animal: "🦆",
    art: "assets/images/ducks-menu.png",
    summary: "Drag the duck carrying the missing digit onto the maths problem.",
    instructions: "Solve the problem and find the duck carrying the missing digit. Drag that duck onto the question mark. Wrong ducks return to the pen. Keep solving before the pen fills up.",
    start: startDigitDucks
  }
};

function beginView({ showControls = true, music = "theme" } = {}) {
  cleanupCurrent();
  cleanupCurrent = () => {};
  gameShell.classList.remove("suzy-active", "menu-transitioning", "returning-to-menu", "world-menu", "world-professor", "world-suzy", "world-gary", "world-ducks");
  gameShell.style.removeProperty("--background-shift");
  app.replaceChildren();
  controls.hidden = !showControls;
  playMusic(music);
}

function playMusic(which) {
  themeAudio.pause();
  garyAudio.pause();
  currentMusic = which;
  if (muted || !which) return;
  const audio = which === "gary" ? garyAudio : themeAudio;
  audio.volume = which === "gary" ? 0.32 : 0.26;
  audio.play().catch(() => {});
}

function playEffect(audio) {
  if (muted) return;
  audio.currentTime = 0;
  audio.volume = 0.72;
  audio.play().catch(() => {});
}

function preloadFrames(directory, start, end) {
  for (let frame = start; frame <= end; frame += 1) {
    const image = new Image();
    image.src = `${directory}/${frame}.png`;
  }
}

function shuffle(values) {
  const result = [...values];
  for (let i = result.length - 1; i > 0; i -= 1) {
    const j = Math.floor(Math.random() * (i + 1));
    [result[i], result[j]] = [result[j], result[i]];
  }
  return result;
}

function escapeHtml(value) {
  return String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#039;");
}

function renderMenu() {
  beginView({ showControls: true, music: "theme" });
  currentGameKey = null;
  homeButton.disabled = false;
  gameShell.classList.add("world-menu");
  app.innerHTML = `
    <section class="menu-screen original-menu" aria-label="Choose a farm learning game">
      ${menuButtonsMarkup()}
    </section>
  `;
  app.querySelectorAll("[data-game]").forEach((button) => {
    button.addEventListener("click", () => transitionFromMenu(button.dataset.game));
  });
}

function menuButtonsMarkup() {
  return Object.entries(gameInfo).map(([key, game]) => `
    <button class="menu-game-button menu-${key}" type="button" data-game="${key}" aria-label="Play ${game.title}">
      <img src="${game.art}" alt="">
      <span class="visually-hidden">${game.title}</span>
    </button>
  `).join("");
}

function setCurrentGame(key) {
  currentGameKey = key;
  const menuIsLeft = pageByGame[key] > 3;
  homeButton.textContent = menuIsLeft ? "←" : "→";
  homeButton.setAttribute("aria-label", menuIsLeft ? "Return left to the farm menu" : "Return right to the farm menu");
}

function transitionFromMenu(key) {
  setCurrentGame(key);
  const page = pageByGame[key];
  const pageDistance = Math.abs(3 - page);
  const direction = 3 - page;
  const foregroundDuration = pageDistance * 1600;
  const farmDuration = pageDistance * 3200;
  const menu = document.querySelector(".original-menu");
  if (!menu || !foregroundDuration) {
    showInstructions(key);
    return;
  }
  menu.style.setProperty("--foreground-shift", `${direction * 1155}px`);
  gameShell.style.setProperty("--midground-shift", `${direction * 500}px`);
  gameShell.style.setProperty("--background-shift", `${direction * 100}px`);
  menu.style.setProperty("--transition-duration", `${foregroundDuration}ms`);
  gameShell.style.setProperty("--farm-transition-duration", `${farmDuration}ms`);
  void gameShell.offsetWidth;
  gameShell.classList.add("menu-transitioning");
  const foregroundShift = direction * 1155;
  const bounceFrames = Array.from({ length: 41 }, (_, index) => {
    const time = index / 40;
    let progress;
    if (time < 1 / 2.75) {
      progress = 7.5625 * time * time;
    } else if (time < 2 / 2.75) {
      const adjusted = time - 1.5 / 2.75;
      progress = 7.5625 * adjusted * adjusted + 0.75;
    } else if (time < 2.5 / 2.75) {
      const adjusted = time - 2.25 / 2.75;
      progress = 7.5625 * adjusted * adjusted + 0.9375;
    } else {
      const adjusted = time - 2.625 / 2.75;
      progress = 7.5625 * adjusted * adjusted + 0.984375;
    }
    return { transform: `translateX(${foregroundShift * progress}px)`, offset: time };
  });
  menu.querySelectorAll(".menu-game-button").forEach((button) => {
    button.animate(bounceFrames, { duration: foregroundDuration, easing: "linear", fill: "forwards" });
  });
  const incomingLogo = document.createElement("img");
  incomingLogo.className = key === "suzy" ? "suzy-transition-logo" : `game-transition-logo game-logo-${key}`;
  incomingLogo.src = gameInfo[key].art;
  incomingLogo.alt = "";
  menu.append(incomingLogo);
  const entryOffset = -direction * 1155;
  const incomingFrames = bounceFrames.map((frame) => ({
    offset: frame.offset,
    transform: `translateX(${entryOffset * (1 - (frame.offset === 1 ? 1 : bounceEaseProgress(frame.offset)))}px)`
  }));
  incomingLogo.animate(incomingFrames, { duration: foregroundDuration, easing: "linear", fill: "forwards" });
  menu.querySelectorAll("button").forEach((button) => { button.disabled = true; });
  window.setTimeout(() => showInstructions(key), foregroundDuration);
}

function transitionToMenu() {
  const key = currentGameKey;
  const page = pageByGame[key];
  if (gameShell.classList.contains("returning-to-menu")) return;
  if (!key || !page) {
    renderMenu();
    return;
  }
  const pageDistance = Math.abs(3 - page);
  const direction = 3 - page;
  const foregroundDuration = pageDistance * 1600;
  const farmDuration = pageDistance * 3200;
  const currentScenes = [...app.children];
  if (!currentScenes.length) {
    renderMenu();
    return;
  }
  cleanupCurrent();
  cleanupCurrent = () => {};
  homeButton.disabled = true;
  gameShell.style.setProperty("--farm-transition-duration", `${farmDuration}ms`);
  void gameShell.offsetWidth;
  gameShell.classList.add("returning-to-menu");

  const exitShift = -direction * 1155;
  const outgoingLayer = document.createElement("div");
  outgoingLayer.className = "returning-current-layer";
  currentScenes.forEach((scene) => outgoingLayer.append(scene));
  app.append(outgoingLayer);
  outgoingLayer.animate([
    { transform: "translateX(0)", opacity: 1 },
    { transform: `translateX(${exitShift}px)`, opacity: 0 }
  ], { duration: foregroundDuration, easing: "linear", fill: "forwards" });

  const incomingMenu = document.createElement("section");
  incomingMenu.className = "menu-screen original-menu returning-menu";
  incomingMenu.setAttribute("aria-label", "Farm learning game menu");
  incomingMenu.innerHTML = menuButtonsMarkup();
  app.append(incomingMenu);
  const entryOffset = direction * 1155;
  const incomingFrames = Array.from({ length: 41 }, (_, index) => {
    const time = index / 40;
    return {
      offset: time,
      transform: `translateX(${entryOffset * (1 - bounceEaseProgress(time))}px)`
    };
  });
  incomingMenu.animate(incomingFrames, { duration: foregroundDuration, easing: "linear", fill: "forwards" });
  window.setTimeout(renderMenu, foregroundDuration);
}

function bounceEaseProgress(time) {
  if (time < 1 / 2.75) return 7.5625 * time * time;
  if (time < 2 / 2.75) {
    const adjusted = time - 1.5 / 2.75;
    return 7.5625 * adjusted * adjusted + 0.75;
  }
  if (time < 2.5 / 2.75) {
    const adjusted = time - 2.25 / 2.75;
    return 7.5625 * adjusted * adjusted + 0.9375;
  }
  const adjusted = time - 2.625 / 2.75;
  return 7.5625 * adjusted * adjusted + 0.984375;
}

function showInstructions(key) {
  setCurrentGame(key);
  const game = gameInfo[key];
  if (key === "professor") {
    preloadFrames("assets/original/professor", 1, 351);
  } else if (key === "suzy") {
    preloadFrames("assets/original/milk", 1, 100);
  } else if (key === "ducks") {
    preloadFrames("originalswfs/farmgameswf/sprites/DefineSprite_48_FarmEducationalGamesPackage_fla.sDuckWalkSW_102", 2, 40);
    preloadFrames("originalswfs/farmgameswf/sprites/DefineSprite_49_FarmEducationalGamesPackage_fla.sDuckWalkSE_103", 2, 40);
    preloadFrames("originalswfs/farmgameswf/sprites/DefineSprite_51_FarmEducationalGamesPackage_fla.sDuckWalkNW_104", 2, 40);
    preloadFrames("originalswfs/farmgameswf/sprites/DefineSprite_52_FarmEducationalGamesPackage_fla.sDuckWalkNE_105", 2, 40);
    preloadFrames("originalswfs/farmgameswf/sprites/DefineSprite_45_FarmEducationalGamesPackage_fla.sDuckSquash_101", 1, 70);
  } else if (key === "gary") {
    preloadFrames("assets/original/farmer", 1, 62);
    preloadFrames("assets/original/gary", 19, 37);
  }
  if (key === "suzy") {
    showSuzyInstructions();
    return;
  }
  if (key === "ducks") {
    showDigitDucksInstructions();
    return;
  }
  beginView({ showControls: true, music: key === "gary" ? "gary" : "theme" });
  gameShell.classList.add(`world-${key}`);
  app.innerHTML = `
    <section class="game-intro-screen game-intro-${key}">
      <img class="game-intro-logo game-logo-${key}" src="${game.art}" alt="${game.title}">
      <div class="game-intro-copy">
        <p>${game.instructions}</p>
        <div class="button-row">
          <button class="primary-button" id="play-game" type="button">Play Game</button>
          <button class="secondary-button" id="instructions-home" type="button">Farm Menu</button>
        </div>
      </div>
    </section>
  `;
  document.querySelector("#play-game").addEventListener("click", game.start);
  document.querySelector("#instructions-home").addEventListener("click", transitionToMenu);
}

function showDigitDucksInstructions() {
  beginView({ showControls: true, music: "theme" });
  setCurrentGame("ducks");
  gameShell.classList.add("world-ducks");
  app.innerHTML = `
    <section class="duck-instructions-screen">
      <img class="game-intro-logo game-logo-ducks duck-instructions-logo" src="assets/images/ducks-menu.png" alt="Digit Ducks">
      <div class="duck-instructions-pen">
        <p>Do you know how to do maths?<br>Do you know how to catch a duck?<br>If you answered YES and YES, then you are ready to play Digit Ducks!</p>
        <p>When the game begins, you will be given a maths problem. One digit will be missing from the problem or answer. Catch the duck with the missing digit and drop it on the big red “?”.</p>
        <p>Solve as many problems as you can before the duck pen gets full!</p>
        <button class="duck-instructions-play" id="play-game" type="button">Play Digit Ducks!</button>
      </div>
    </section>
  `;
  document.querySelector("#play-game").addEventListener("click", startDigitDucks);
}

function showSuzyInstructions() {
  beginView({ showControls: true, music: "theme" });
  gameShell.classList.add("suzy-active", "world-suzy");
  app.innerHTML = `
    <section class="suzy-scene suzy-instructions-screen">
      <img class="suzy-scene-logo" src="assets/images/suzy-menu.png" alt="Suzy Sow's Spelling">
      <img class="suzy-scene-bottle" src="assets/original/milk/1.png" alt="Full milk bottle">
      <div class="suzy-side-controls" aria-hidden="true">
        <span class="suzy-word-control">Show<br>Word</span>
        <span class="suzy-pause-control">Pause</span>
        <span class="suzy-score-disc">0</span>
      </div>
      <div class="suzy-instruction-copy">
        <p>Find as many words as you can<br>before Suzy’s milk runs out!</p>
        <p>You will be given a word,<br>then you will see a box full<br>of letters. Click adjoining<br>letters to spell the word.</p>
        <p>If you forget how to spell<br>a word, click “Show Word”.</p>
        <strong>Good luck!</strong>
        <button class="suzy-play-button" id="play-game" type="button">Play</button>
      </div>
    </section>
  `;
  document.querySelector("#play-game").addEventListener("click", startSuzySow);
}

function showEndCard({ title, message, animal, art, playAgain, music = "theme" }) {
  beginView({ showControls: true, music });
  if (currentGameKey) gameShell.classList.add(`world-${currentGameKey}`);
  app.innerHTML = `
    <section class="modal-card instructions">
      ${art ? `<img class="mascot-image" src="${art}" alt="">` : `<span class="mascot" aria-hidden="true">${animal}</span>`}
      <h2>${title}</h2>
      <p style="text-align:center">${message}</p>
      <div class="button-row">
        <button class="primary-button" id="play-again" type="button">Play Again</button>
        <button class="secondary-button" id="end-home" type="button">Farm Menu</button>
      </div>
    </section>
  `;
  document.querySelector("#play-again").addEventListener("click", playAgain);
  document.querySelector("#end-home").addEventListener("click", transitionToMenu);
}

function popFeedback(container, text) {
  const pop = document.createElement("div");
  pop.className = "feedback-pop";
  pop.textContent = text;
  container.append(pop);
  setTimeout(() => pop.remove(), 720);
}

// Professor Chicken ---------------------------------------------------------

function startProfessorChicken() {
  beginView({ showControls: true, music: "theme" });
  gameShell.classList.add("world-professor");
  const settings = config.professorChicken;
  const available = settings.randomize ? shuffle(settings.questions) : [...settings.questions];
  const questions = available.slice(0, Math.min(settings.numberOfQuestions, available.length));
  let index = 0;
  let correct = 0;
  let professorTimer;

  function playProfessorAnimation(startFrame, endFrame) {
    clearInterval(professorTimer);
    const professor = document.querySelector("#professor-character");
    if (!professor) return;
    let frame = startFrame;
    professor.src = `assets/original/professor/${frame}.png`;
    professorTimer = window.setInterval(() => {
      frame += 1;
      professor.src = `assets/original/professor/${Math.min(frame, endFrame)}.png`;
      if (frame >= endFrame) clearInterval(professorTimer);
    }, 1000 / 60);
  }

  function renderQuestion() {
    const question = questions[index];
    app.innerHTML = `
      <section class="screen">
        <header class="screen-header"><h1>Professor Chicken</h1><span class="header-stat">Correct: ${correct}</span></header>
        <div class="chicken-layout">
          <img class="chicken-character" id="professor-character" src="assets/original/professor/1.png" alt="Professor Chicken">
          <div class="blackboard panel">
            <div class="question-count">Question ${index + 1} of ${questions.length}</div>
            <div class="question-text">${escapeHtml(question.text)}</div>
            <div class="answer-list">
              ${question.answers.map((answer, answerIndex) => `<button class="answer-button" type="button" data-answer="${answerIndex}">${escapeHtml(answer.text)}</button>`).join("")}
            </div>
            <div class="button-row" id="question-actions"></div>
          </div>
        </div>
      </section>
    `;
    playProfessorAnimation(235, 351);

    app.querySelectorAll("[data-answer]").forEach((button) => {
      button.addEventListener("click", () => {
        const selected = question.answers[Number(button.dataset.answer)];
        if (selected.correct) correct += 1;
        playEffect(selected.correct ? happyAudio : unhappyAudio);
        const professor = document.querySelector("#professor-character");
        professor.classList.add("reaction");
        playProfessorAnimation(selected.correct ? 1 : 118, selected.correct ? 117 : 234);

        app.querySelectorAll("[data-answer]").forEach((answerButton) => {
          answerButton.disabled = true;
          const answer = question.answers[Number(answerButton.dataset.answer)];
          answerButton.classList.add(answer.correct ? "correct" : answerButton === button ? "wrong" : "faded");
        });

        const actions = document.querySelector("#question-actions");
        const next = document.createElement("button");
        next.type = "button";
        next.className = "primary-button";
        next.textContent = index + 1 === questions.length ? "See My Rank" : "Next Question";
        next.addEventListener("click", () => {
          index += 1;
          if (index < questions.length) renderQuestion();
          else finishProfessor();
        });
        actions.append(next);
      }, { once: true });
    });
  }

  function finishProfessor() {
    const percentage = questions.length ? correct / questions.length : 0;
    let rank = "Chicken Professor";
    if (percentage < 0.7) rank = "Professor’s Assistant";
    if (percentage < 0.5) rank = "Hatchling";
    showEndCard({
      title: rank,
      message: `You answered <strong>${correct} of ${questions.length}</strong> questions correctly.`,
      animal: "🐔",
      art: "assets/images/professor-menu.png",
      playAgain: startProfessorChicken
    });
  }

  cleanupCurrent = () => clearInterval(professorTimer);
  renderQuestion();
}

// Suzy Sow ------------------------------------------------------------------

function startSuzySow() {
  beginView({ showControls: true, music: "theme" });
  gameShell.classList.add("suzy-active", "world-suzy");
  const settings = config.suzySow;
  const eligibleWords = settings.words.filter((word) => word.length <= settings.gridSize - 2);
  let wordQueue = shuffle(eligibleWords);
  let currentWord = "";
  let currentPath = [];
  let selected = [];
  let score = 0;
  let remaining = settings.startTimeSeconds;
  let paused = true;
  let timerId;
  let completionTimer;
  let pauseOverlay;

  app.innerHTML = `
    <section class="suzy-scene suzy-game-screen">
      <img class="suzy-scene-logo" src="assets/images/suzy-menu.png" alt="Suzy Sow’s Spelling">
      <img class="suzy-scene-bottle" id="milk-bottle" src="assets/original/milk/1.png" alt="Milk bottle showing time remaining">
      <aside class="suzy-side-controls">
        <button class="suzy-word-control" id="show-word-button" type="button">Show<br>Word</button>
        <button class="suzy-pause-control" id="suzy-pause" type="button">Pause</button>
        <div class="suzy-score-disc" id="suzy-score" aria-label="Words found">0</div>
      </aside>
      <div class="word-grid-panel"><div class="word-grid" id="word-grid"></div></div>
    </section>
  `;

  const gridElement = document.querySelector("#word-grid");
  const scoreElement = document.querySelector("#suzy-score");
  const milkElement = document.querySelector("#milk-bottle");
  const pauseButton = document.querySelector("#suzy-pause");
  const showWordButton = document.querySelector("#show-word-button");
  showWordButton.addEventListener("click", () => revealWord(false));
  pauseButton.addEventListener("click", pauseSuzy);

  function updateSuzyHud() {
    scoreElement.textContent = score;
    scoreElement.setAttribute("aria-label", `${score} ${score === 1 ? "word" : "words"} found`);
    const ratio = Math.max(0, Math.min(1, remaining / settings.startTimeSeconds));
    const milkFrame = 1 + Math.round((1 - ratio) * 99);
    milkElement.src = `assets/original/milk/${milkFrame}.png`;
  }

  function nextWord() {
    if (!wordQueue.length) wordQueue = shuffle(eligibleWords);
    currentWord = wordQueue.pop().toUpperCase();
    clearSelection();
    revealWord(true);
  }

  function renderWordGrid(letters) {
    gridElement.style.gridTemplateColumns = `repeat(${settings.gridSize}, 1fr)`;
    gridElement.replaceChildren();
    letters.forEach((letter, index) => {
      const tile = document.createElement("button");
      tile.type = "button";
      tile.className = "letter-tile";
      tile.textContent = letter;
      tile.dataset.index = index;
      tile.addEventListener("click", () => selectLetter(index, tile));
      gridElement.append(tile);
    });
  }

  function selectLetter(index, tile) {
    if (paused || selected.includes(index)) return;
    if (!isValidNextTile(index, tile)) {
      clearSelection();
      if (!isValidNextTile(index, tile)) return;
    }
    selected.push(index);
    tile.classList.add("selected");
    if (selected.length === currentWord.length) {
      paused = true;
      currentPath.forEach((tileIndex) => gridElement.children[tileIndex]?.classList.add("found"));
      score += currentWord.length * 2;
      remaining = Math.min(settings.startTimeSeconds, remaining + settings.addTimeSeconds);
      updateSuzyHud();
      popFeedback(document.querySelector(".word-grid-panel"), `+${settings.addTimeSeconds} seconds!`);
      completionTimer = window.setTimeout(nextWord, 1000);
    }
  }

  function isValidNextTile(index, tile) {
    const nextLetter = currentWord[selected.length];
    if (Number(settings.hideDifficulty) !== 3) {
      return index === currentPath[selected.length];
    }
    if (tile.textContent !== nextLetter) return false;
    const previous = selected.at(-1);
    if (previous === undefined) return true;
    const px = previous % settings.gridSize;
    const py = Math.floor(previous / settings.gridSize);
    const x = index % settings.gridSize;
    const y = Math.floor(index / settings.gridSize);
    return Math.abs(x - px) + Math.abs(y - py) === 1;
  }

  function clearSelection() {
    selected = [];
    gridElement.querySelectorAll(".selected, .found").forEach((item) => item.classList.remove("selected", "found"));
  }

  function revealWord(isNewWord = false) {
    if (!currentWord) return;
    paused = true;
    clearSelection();
    gridElement.classList.add("letters-hidden");
    showWordButton.disabled = true;
    pauseButton.disabled = true;
    const overlay = document.createElement("div");
    overlay.className = "modal-card";
    overlay.classList.add("suzy-word-overlay");
    overlay.innerHTML = `<div class="word-reveal">${escapeHtml(currentWord)}</div><button class="suzy-ok-button" type="button">OK</button>`;
    app.append(overlay);
    overlay.querySelector("button").addEventListener("click", () => {
      overlay.remove();
      if (isNewWord) {
        const generated = makeWordGrid(currentWord, settings.gridSize, settings.hideDifficulty);
        currentPath = generated.path;
        renderWordGrid(generated.letters);
      }
      gridElement.classList.remove("letters-hidden");
      paused = false;
      showWordButton.disabled = false;
      pauseButton.disabled = false;
    });
  }

  function pauseSuzy() {
    if (paused || pauseOverlay) return;
    paused = true;
    gridElement.classList.add("letters-hidden");
    showWordButton.disabled = true;
    pauseButton.disabled = true;
    pauseOverlay = document.createElement("div");
    pauseOverlay.className = "suzy-pause-overlay";
    pauseOverlay.innerHTML = `<button type="button">Resume</button>`;
    app.append(pauseOverlay);
    pauseOverlay.querySelector("button").addEventListener("click", () => {
      pauseOverlay.remove();
      pauseOverlay = null;
      gridElement.classList.remove("letters-hidden");
      showWordButton.disabled = false;
      pauseButton.disabled = false;
      paused = false;
    });
  }

  function finishSuzy() {
    paused = true;
    clearInterval(timerId);
    const overlay = document.createElement("div");
    overlay.className = "suzy-game-over";
    overlay.innerHTML = `
      <strong>Oh!!!</strong>
      <span>Suzy’s milk is all gone!</span>
      <button id="suzy-play-again" type="button">Play Again!</button>
      <button id="suzy-end-home" type="button">Farm Menu</button>
    `;
    app.append(overlay);
    document.querySelector("#suzy-play-again").addEventListener("click", startSuzySow);
    document.querySelector("#suzy-end-home").addEventListener("click", transitionToMenu);
  }

  timerId = window.setInterval(() => {
    if (paused || document.hidden) return;
    remaining -= 0.25;
    updateSuzyHud();
    if (remaining <= 0) {
      finishSuzy();
    }
  }, 250);
  cleanupCurrent = () => {
    clearInterval(timerId);
    clearTimeout(completionTimer);
  };
  updateSuzyHud();
  nextWord();
}

function makeWordGrid(word, size, difficulty) {
  const alphabet = "EEEEEEEEEEEEAAAAAAAAAIIIIIIIIIOOOOOOOONNNNNNRRRRRRTTTTTTLLLLSSSSUUUUDDDDGGGGBBCCMMPPFFHHVVWWYYKJXQZ";
  const letterPool = alphabet + word.repeat(Number(difficulty) + 1);
  const letters = Array.from({ length: size * size }, () => letterPool[Math.floor(Math.random() * letterPool.length)]);
  let path;

  if (Number(difficulty) === 3) {
    path = makeSnakePath(size, word.length);
  } else {
    const fiveDirections = [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1]];
    const allDirections = [...fiveDirections, [-1, 1], [-1, 0], [-1, -1]];
    const directions = Number(difficulty) === 2 ? allDirections : fiveDirections;
    const candidates = [];
    for (const [dx, dy] of directions) {
      for (let y = 0; y < size; y += 1) {
        for (let x = 0; x < size; x += 1) {
          const endX = x + dx * (word.length - 1);
          const endY = y + dy * (word.length - 1);
          if (endX >= 0 && endX < size && endY >= 0 && endY < size) {
            candidates.push(Array.from({ length: word.length }, (_, index) => (y + dy * index) * size + x + dx * index));
          }
        }
      }
    }
    path = candidates[Math.floor(Math.random() * candidates.length)];
  }

  path.forEach((index, letterIndex) => { letters[index] = word[letterIndex]; });
  return { letters, path };
}

function makeSnakePath(size, length) {
  const directions = [[1, 0], [-1, 0], [0, 1], [0, -1]];
  for (let attempt = 0; attempt < 100; attempt += 1) {
    const start = Math.floor(Math.random() * size * size);
    const path = [start];
    while (path.length < length) {
      const current = path.at(-1);
      const x = current % size;
      const y = Math.floor(current / size);
      const choices = shuffle(directions)
        .map(([dx, dy]) => ({ x: x + dx, y: y + dy }))
        .filter((point) => point.x >= 0 && point.x < size && point.y >= 0 && point.y < size)
        .map((point) => point.y * size + point.x)
        .filter((index) => !path.includes(index));
      if (!choices.length) break;
      path.push(choices[0]);
    }
    if (path.length === length) return path;
  }
  return Array.from({ length }, (_, index) => index);
}

// Digit Ducks ---------------------------------------------------------------

function startDigitDucks() {
  beginView({ showControls: true, music: "theme" });
  setCurrentGame("ducks");
  gameShell.classList.add("world-ducks");
  const settings = config.digitDucks;
  let problems = shuffle(settings.problems);
  let score = 0;
  let duckCount = 0;
  let targetDigit = "0";
  let locked = false;
  let running = true;
  let spawnTimer;
  let nextProblemTimer;
  let animationFrame;
  let previousTime = performance.now();
  const ducks = new Map();
  const walkFrames = {
    sw: "originalswfs/farmgameswf/sprites/DefineSprite_48_FarmEducationalGamesPackage_fla.sDuckWalkSW_102",
    se: "originalswfs/farmgameswf/sprites/DefineSprite_49_FarmEducationalGamesPackage_fla.sDuckWalkSE_103",
    nw: "originalswfs/farmgameswf/sprites/DefineSprite_51_FarmEducationalGamesPackage_fla.sDuckWalkNW_104",
    ne: "originalswfs/farmgameswf/sprites/DefineSprite_52_FarmEducationalGamesPackage_fla.sDuckWalkNE_105"
  };
  const grabbedFrames = "originalswfs/farmgameswf/sprites/DefineSprite_45_FarmEducationalGamesPackage_fla.sDuckSquash_101";
  const directionVectors = { nw: [-1, -1], ne: [1, -1], sw: [-1, 1], se: [1, 1] };
  const directions = Object.keys(directionVectors);

  app.innerHTML = `
    <section class="screen">
      <header class="screen-header"><h1>Digit Ducks</h1><span class="header-stat" id="duck-score">Score: 0</span></header>
      <div class="duck-layout original-duck-layout">
        <aside class="problem-panel panel">
          <p>Which digit is missing?</p>
          <div class="math-problem" id="math-problem"></div>
          <strong id="duck-count">There are 0 of ${settings.maxDucks} ducks in the pen!</strong>
        </aside>
        <div class="duck-pen panel" id="duck-pen" aria-label="Duck pen"></div>
      </div>
    </section>
  `;

  const pen = document.querySelector("#duck-pen");
  const problemElement = document.querySelector("#math-problem");
  const scoreElement = document.querySelector("#duck-score");
  const countElement = document.querySelector("#duck-count");

  function nextProblem() {
    if (!problems.length) problems = shuffle(settings.problems);
    const problem = parseProblem(problems.pop());
    const operandName = Math.random() < 0.5 ? "left" : "right";
    const operand = String(problem[operandName]);
    const hiddenIndex = Math.floor(Math.random() * operand.length);
    targetDigit = operand[hiddenIndex];
    const hiddenOperand = `${escapeHtml(operand.slice(0, hiddenIndex))}<span class="missing-digit">?</span>${escapeHtml(operand.slice(hiddenIndex + 1))}`;
    const leftLine = operandName === "left" ? hiddenOperand : escapeHtml(problem.left);
    const rightLine = operandName === "right" ? hiddenOperand : escapeHtml(problem.right);
    problemElement.dataset.targetDigit = targetDigit;
    problemElement.innerHTML = `
      <span class="duck-equation-line">${leftLine}</span>
      <span class="duck-equation-line duck-equation-operator"><b>${escapeHtml(problem.operator)}</b>${rightLine}</span>
      <span class="duck-equation-rule"></span>
      <span class="duck-equation-line">${escapeHtml(problem.result)}</span>
    `;
    locked = false;
  }

  function spawnDuck() {
    if (locked) return;
    const digit = String(Math.floor(Math.random() * 9));
    const duck = document.createElement("button");
    duck.type = "button";
    duck.className = "duck";
    const direction = directions[Math.floor(Math.random() * directions.length)];
    duck.innerHTML = `<img src="${walkFrames[direction]}/2.png" alt="">`;
    duck.dataset.digit = digit;
    duck.setAttribute("aria-label", `Duck with digit ${digit}`);
    pen.append(duck);
    const maxX = Math.max(0, pen.clientWidth - duck.offsetWidth);
    const maxY = Math.max(0, pen.clientHeight - duck.offsetHeight);
    const state = {
      x: Math.floor(Math.random() * Math.max(1, maxX)),
      y: -duck.offsetHeight,
      dropY: Math.floor(Math.random() * Math.max(1, maxY)),
      direction,
      frame: 2,
      frameElapsed: 0,
      grabFrame: 1,
      grabElapsed: 0,
      status: "dropping",
      counted: false
    };
    ducks.set(duck, state);
    positionDuck(duck, state);
    enableDuckDrag(duck, state);
  }

  function positionDuck(duck, state) {
    duck.style.left = `${state.x}px`;
    duck.style.top = `${state.y}px`;
  }

  function showWalkFrame(duck, state) {
    duck.querySelector("img").src = `${walkFrames[state.direction]}/${state.frame}.png`;
  }

  function resumeDuck(duck, state) {
    duck.classList.remove("dragging", "grabbed");
    state.status = "walking";
    state.direction = directions[Math.floor(Math.random() * directions.length)];
    state.frame = 2;
    showWalkFrame(duck, state);
  }

  function returnDuckToPen(duck, state) {
    const maxX = Math.max(0, pen.clientWidth - duck.offsetWidth);
    const maxY = Math.max(0, pen.clientHeight - duck.offsetHeight);
    if (state.x < 0 || state.y < 0 || state.x > maxX || state.y > maxY) {
      state.status = "returning";
      state.x = Math.floor(Math.random() * Math.max(1, maxX));
      state.y = Math.floor(Math.random() * Math.max(1, maxY));
      duck.style.transition = "left .3s linear, top .3s linear";
      positionDuck(duck, state);
      window.setTimeout(() => {
        if (!ducks.has(duck)) return;
        duck.style.transition = "";
        resumeDuck(duck, state);
      }, 300);
    } else {
      resumeDuck(duck, state);
    }
  }

  function enableDuckDrag(duck, state) {
    duck.addEventListener("pointerdown", (event) => {
      if (locked) return;
      event.preventDefault();
      duck.setPointerCapture(event.pointerId);
      state.status = "dragging";
      state.grabFrame = 1;
      state.grabElapsed = 0;
      duck.classList.add("dragging", "grabbed");
      duck.querySelector("img").src = `${grabbedFrames}/1.png`;
      pen.append(duck);
      playEffect(grabDuckAudio);
      const penRect = pen.getBoundingClientRect();

      const move = (moveEvent) => {
        state.x = moveEvent.clientX - penRect.left - duck.offsetWidth / 2;
        state.y = moveEvent.clientY - penRect.top - duck.offsetHeight / 2;
        positionDuck(duck, state);
        const duckRect = duck.getBoundingClientRect();
        const targetRect = problemElement.querySelector(".missing-digit").getBoundingClientRect();
        const overTarget = duckRect.right > targetRect.left && duckRect.left < targetRect.right && duckRect.bottom > targetRect.top && duckRect.top < targetRect.bottom;
        problemElement.querySelector(".missing-digit").classList.toggle("highlight", overTarget);
      };

      const release = () => {
        duck.removeEventListener("pointermove", move);
        duck.removeEventListener("pointerup", release);
        duck.removeEventListener("pointercancel", release);
        problemElement.querySelector(".missing-digit").classList.remove("highlight");
        const duckRect = duck.getBoundingClientRect();
        const targetRect = problemElement.querySelector(".missing-digit").getBoundingClientRect();
        const droppedOnTarget = duckRect.right > targetRect.left && duckRect.left < targetRect.right && duckRect.bottom > targetRect.top && duckRect.top < targetRect.bottom;
        if (!droppedOnTarget) {
          returnDuckToPen(duck, state);
          return;
        }

        if (duck.dataset.digit === targetDigit) {
          locked = true;
          playEffect(correctDuckAudio);
          score += 1;
          if (state.counted) duckCount -= 1;
          ducks.delete(duck);
          duck.remove();
          const missingDigit = problemElement.querySelector(".missing-digit");
          missingDigit.textContent = targetDigit;
          missingDigit.classList.add("correct");
          popFeedback(document.querySelector(".problem-panel"), "Correct!");
          updateDuckHud();
          nextProblemTimer = window.setTimeout(nextProblem, 3000);
        } else {
          popFeedback(document.querySelector(".problem-panel"), "Try another duck");
          returnDuckToPen(duck, state);
        }
      };

      duck.addEventListener("pointermove", move);
      duck.addEventListener("pointerup", release);
      duck.addEventListener("pointercancel", release);
    });
  }

  function updateDuckHud() {
    scoreElement.textContent = `Score: ${score}`;
    countElement.textContent = duckCount === 1
      ? `There is 1 of ${settings.maxDucks} ducks in the pen!`
      : `There are ${duckCount} of ${settings.maxDucks} ducks in the pen!`;
  }

  function animateDucks(time) {
    const delta = Math.min(0.05, (time - previousTime) / 1000);
    previousTime = time;
    if (!locked) {
      ducks.forEach((state, duck) => {
        if (state.status === "dropping") {
          state.y = Math.min(state.dropY, state.y + 150 * delta);
          if (state.y >= state.dropY) {
            state.status = "walking";
            state.counted = true;
            duckCount += 1;
            updateDuckHud();
            if (duckCount >= settings.maxDucks) finishDucks();
          }
          positionDuck(duck, state);
        } else if (state.status === "walking") {
          const maxX = Math.max(0, pen.clientWidth - duck.offsetWidth);
          const maxY = Math.max(0, pen.clientHeight - duck.offsetHeight);
          const [dx, dy] = directionVectors[state.direction];
          const nextX = state.x + dx * 20 * delta;
          const nextY = state.y + dy * 20 * delta;
          let choices;
          if (nextX > maxX) choices = ["nw", "sw"];
          if (nextX < 0) choices = ["ne", "se"];
          if (nextY > maxY) choices = ["nw", "ne"];
          if (nextY < 0) choices = ["sw", "se"];
          if (choices) {
            state.direction = choices[Math.floor(Math.random() * choices.length)];
          } else {
            state.x = nextX;
            state.y = nextY;
            positionDuck(duck, state);
          }
          state.frameElapsed += delta;
          if (state.frameElapsed >= 0.08) {
            state.frameElapsed = 0;
            state.frame = state.frame >= 40 ? 2 : state.frame + 1;
            showWalkFrame(duck, state);
          }
        } else if (state.status === "dragging") {
          state.grabElapsed += delta;
          if (state.grabElapsed >= 0.035 && state.grabFrame < 70) {
            state.grabElapsed = 0;
            state.grabFrame += 1;
            duck.querySelector("img").src = `${grabbedFrames}/${state.grabFrame}.png`;
          }
        }
      });
    }
    if (running) animationFrame = requestAnimationFrame(animateDucks);
  }

  function finishDucks() {
    if (!running) return;
    running = false;
    clearInterval(spawnTimer);
    clearTimeout(nextProblemTimer);
    cancelAnimationFrame(animationFrame);
    showEndCard({
      title: "The Duck Pen Is Full!",
      message: `You solved <strong>${score}</strong> maths ${score === 1 ? "problem" : "problems"}.`,
      animal: "🦆",
      art: "assets/images/ducks-menu.png",
      playAgain: startDigitDucks
    });
  }

  nextProblem();
  spawnDuck();
  spawnTimer = window.setInterval(spawnDuck, 2000);
  animationFrame = requestAnimationFrame(animateDucks);
  cleanupCurrent = () => {
    running = false;
    clearInterval(spawnTimer);
    clearTimeout(nextProblemTimer);
    cancelAnimationFrame(animationFrame);
  };
}

function parseProblem(text) {
  const match = String(text).match(/^\s*(\d+)\s*([+\-*/])\s*(\d+)\s*$/);
  if (!match) throw new Error(`Invalid Digit Ducks problem: ${text}`);
  const left = Number(match[1]);
  const right = Number(match[3]);
  const operator = match[2];
  const result = operator === "+" ? left + right
    : operator === "-" ? left - right
      : operator === "*" ? left * right
        : left / right;
  return { left, right, operator: operator === "*" ? "×" : operator === "/" ? "÷" : operator, result };
}

// Gary Goat -----------------------------------------------------------------

function showGaryGroupSelector() {
  beginView({ showControls: true, music: "gary" });
  gameShell.classList.add("world-gary");
  app.innerHTML = `
    <section class="modal-card instructions">
      <img class="mascot-image" src="assets/images/gary-menu.png" alt="Gary Goat">
      <h2>Select a Group</h2>
      <p style="text-align:center">Which kind of word should Gary eat?</p>
      <div class="group-options">
        ${config.garyGoat.targetGroups.map((group, index) => `<button class="group-option" type="button" data-group="${index}">${escapeHtml(group.title)}</button>`).join("")}
      </div>
      <div class="button-row"><button class="secondary-button" id="gary-home" type="button">Farm Menu</button></div>
    </section>
  `;
  app.querySelectorAll("[data-group]").forEach((button) => {
    button.addEventListener("click", () => startGaryGoat(Number(button.dataset.group)));
  });
  document.querySelector("#gary-home").addEventListener("click", transitionToMenu);
}

function startGaryGoat(groupIndex) {
  beginView({ showControls: true, music: "gary" });
  gameShell.classList.add("world-gary");
  const groups = config.garyGoat.targetGroups;
  const chosenGroup = groups[groupIndex];
  const wordPool = groups.flatMap((group) => group.words.map((word) => ({ word, group: group.title })));
  let score = 0;
  let health = 3;
  let goatX = 350;
  let previousGoatX = goatX;
  let lastTime = performance.now();
  let throwStarted = -Infinity;
  let currentFarmerFrame = 0;
  let currentGoatFrame = 0;
  let running = true;
  let animationFrame;
  let spawnTimer;
  const fallingWords = [];

  app.innerHTML = `
    <section class="screen" style="padding:72px 20px 18px">
      <header class="screen-header"><h1>Gary Goat’s Grammar Grabber</h1></header>
      <div class="gary-field panel" id="gary-field">
        <div class="gary-hud"><span>Eat: ${escapeHtml(chosenGroup.title)}</span><span id="gary-score">Score: 0</span><span id="gary-health">Health: ♥♥♥</span></div>
        <img class="farmer" id="farmer" src="assets/original/farmer/1.png" alt="Farmer Fred">
        <img class="goat" id="goat" src="assets/original/gary/19.png" alt="Gary Goat">
      </div>
    </section>
  `;

  const field = document.querySelector("#gary-field");
  const farmer = document.querySelector("#farmer");
  const goat = document.querySelector("#goat");
  const scoreElement = document.querySelector("#gary-score");
  const healthElement = document.querySelector("#gary-health");
  goat.style.left = `${goatX}px`;

  function moveGoat(event) {
    const rect = field.getBoundingClientRect();
    const nextGoatX = Math.max(55, Math.min(field.clientWidth - 55, event.clientX - rect.left));
    if (Math.abs(nextGoatX - previousGoatX) > 2) {
      goat.classList.toggle("faces-right", nextGoatX > previousGoatX);
    }
    goatX = nextGoatX;
    previousGoatX = nextGoatX;
    goat.style.left = `${goatX}px`;
  }

  function throwWord() {
    if (!running) return;
    throwStarted = performance.now();
    const data = wordPool[Math.floor(Math.random() * wordPool.length)];
    const element = document.createElement("div");
    element.className = "falling-word";
    element.textContent = data.word;
    field.append(element);
    const farmerX = Number.parseFloat(farmer.style.left) || field.clientWidth / 2;
    fallingWords.push({
      element,
      word: data.word,
      group: data.group,
      x: farmerX + 60,
      y: 95,
      speed: 72 + Math.random() * 40
    });
  }

  function eatWord() {
    if (!running) return;
    const goatY = field.clientHeight - 72;
    let nearest;
    let bestDistance = Infinity;
    fallingWords.forEach((word) => {
      const dx = Math.abs(word.x - goatX);
      const dy = Math.abs(word.y - goatY);
      const distance = dx + dy;
      if (dx < 82 && dy < 85 && distance < bestDistance) {
        nearest = word;
        bestDistance = distance;
      }
    });
    if (!nearest) return;

    const index = fallingWords.indexOf(nearest);
    fallingWords.splice(index, 1);
    nearest.element.remove();
    goat.classList.remove("chomp");
    requestAnimationFrame(() => goat.classList.add("chomp"));
    setTimeout(() => goat.classList.remove("chomp"), 350);
    if (nearest.group === chosenGroup.title) {
      score += 1;
      scoreElement.textContent = `Score: ${score}`;
      popFeedback(field, "+1 Good word!");
    } else {
      health -= 1;
      healthElement.textContent = `Health: ${"♥".repeat(health)}${"♡".repeat(3 - health)}`;
      popFeedback(field, `That was ${nearest.group}`);
      if (health <= 0) finishGary();
    }
  }

  function update(time) {
    if (!running) return;
    const delta = Math.min(0.05, (time - lastTime) / 1000);
    lastTime = time;
    const farmerX = (Math.sin(time / 1150) * 0.5 + 0.5) * (field.clientWidth - 100);
    farmer.style.left = `${farmerX}px`;
    farmer.classList.toggle("faces-right", Math.cos(time / 1150) > 0);

    const throwElapsed = time - throwStarted;
    const nextFarmerFrame = throwElapsed >= 0 && throwElapsed < 800
      ? 39 + Math.min(23, Math.floor((throwElapsed / 800) * 24))
      : 1 + (Math.floor(time / 85) % 35);
    if (nextFarmerFrame !== currentFarmerFrame) {
      currentFarmerFrame = nextFarmerFrame;
      farmer.src = `assets/original/farmer/${currentFarmerFrame}.png`;
    }

    const nextGoatFrame = 19 + (Math.floor(time / 80) % 19);
    if (nextGoatFrame !== currentGoatFrame) {
      currentGoatFrame = nextGoatFrame;
      goat.src = `assets/original/gary/${currentGoatFrame}.png`;
    }
    for (let i = fallingWords.length - 1; i >= 0; i -= 1) {
      const word = fallingWords[i];
      word.y += word.speed * delta;
      word.element.style.left = `${word.x}px`;
      word.element.style.top = `${word.y}px`;
      if (word.y > field.clientHeight + 30) {
        word.element.remove();
        fallingWords.splice(i, 1);
      }
    }
    animationFrame = requestAnimationFrame(update);
  }

  function finishGary() {
    running = false;
    clearInterval(spawnTimer);
    cancelAnimationFrame(animationFrame);
    showEndCard({
      title: "Gary Has a Tummy Ache!",
      message: `Gary correctly ate <strong>${score}</strong> ${escapeHtml(chosenGroup.title.toLowerCase())}.`,
      animal: "🐐",
      art: "assets/images/gary-menu.png",
      playAgain: showGaryGroupSelector,
      music: "gary"
    });
  }

  field.addEventListener("pointermove", moveGoat);
  field.addEventListener("pointerdown", (event) => {
    moveGoat(event);
    eatWord();
  });
  throwWord();
  spawnTimer = window.setInterval(throwWord, 1250);
  animationFrame = requestAnimationFrame(update);
  cleanupCurrent = () => {
    running = false;
    clearInterval(spawnTimer);
    cancelAnimationFrame(animationFrame);
  };
}

homeButton.addEventListener("click", transitionToMenu);
soundButton.addEventListener("click", () => {
  muted = !muted;
  soundButton.textContent = muted ? "×" : "♪";
  soundButton.setAttribute("aria-label", muted ? "Unmute sound" : "Mute sound");
  if (muted) {
    themeAudio.pause();
    garyAudio.pause();
  } else {
    playMusic(currentMusic);
  }
});
fullscreenButton.addEventListener("click", () => {
  if (document.fullscreenElement) document.exitFullscreen();
  else gameShell.requestFullscreen().catch(() => {});
});

window.addEventListener("beforeunload", () => cleanupCurrent());

fetch("config.json")
  .then((response) => {
    if (!response.ok) throw new Error(`Configuration request failed: ${response.status}`);
    return response.json();
  })
  .then((loadedConfig) => {
    config = loadedConfig;
    renderMenu();
  })
  .catch((error) => {
    console.error(error);
    app.innerHTML = `<section class="modal-card error-card"><h1>Could not load the farm</h1><p>Run the game through a local web server so the browser can read <code>config.json</code>.</p></section>`;
  });
