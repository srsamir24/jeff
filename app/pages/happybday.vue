<template>
  <div v-if="authLoading" class="gate">
    <div class="loader">Loading...</div>
  </div>

  <div v-else-if="!isAuthorized" class="gate">
    <h1 class="gate-title">🔒 Private Page</h1>
    <p class="gate-text">This page is locked. Please sign in to continue.</p>
    <NuxtLink to="/login" class="gate-btn">Sign In</NuxtLink>
  </div>

  <div v-else class="wrapped-app">

    <Head>
      <Meta name="robots" content="noindex, nofollow" />
      <Title>Your Birthday Wrapped</Title>
    </Head>

    <audio ref="bgMusic" loop preload="auto">
      <source src="/music/TIKI TIKI (Slowed).mp3" type="audio/mpeg" />
    </audio>
    <audio ref="bpMusic" loop preload="auto"></audio>
    <audio ref="dmMusic" loop preload="auto"></audio>

    <!-- Start Screen -->
    <div v-if="!isStarted" class="start-screen" @click="startExperience">
      <div class="start-content">
        <h1>{{ t.start_title }}</h1>
        <p>{{ t.start_sub }}</p>
        <button class="play-btn">{{ t.start_btn }}</button>
        <p class="headphones-hint">{{ t.start_headphones }}</p>
      </div>
      <button class="lang-toggle start-lang" @click.stop="toggleLang">
        {{ lang === 'en' ? '🇷🇺 RU' : '🇬🇧 EN' }}
      </button>
      <div class="blob blob-1"></div>
      <div class="blob blob-2"></div>
    </div>

    <!-- Story -->
    <div v-else class="story-container" :style="{ background: currentGradient }" @click="handleTap">

      <div class="story-progress">
        <div v-for="(slide, index) in slides" :key="index" class="dash-track">
          <div class="dash-fill" :class="{ 'filled': index < currentSlide, 'active': index === currentSlide }"></div>
        </div>
      </div>

      <button class="lang-toggle story-lang" @click.stop="toggleLang">
        {{ lang === 'en' ? '🇷🇺 RU' : '🇬🇧 EN' }}
      </button>

      <Transition name="slide-up" mode="out-in">

        <!-- 0: Opener -->
        <div v-if="currentSlide === 0" class="slide center-align" key="s0">
          <p class="eyebrow">{{ t.s0_eyebrow }}</p>
          <img src="/images/jeffwar.png" alt="" class="opener-img delay-1" />
          <h2 class="massive-text delay-2">{{ t.s0_h }}</h2>
          <p class="story-text delay-3" v-html="t.s0_p"></p>
        </div>

        <!-- 1: Origin -->
        <div v-else-if="currentSlide === 1" class="slide center-align" key="s1">
          <div class="matchup">
            <div class="char-portrait">
              <img src="/images/absolutecinemajeff.png" alt="Jeff" class="jeff-img" />
              <span>{{ t.s1_label_jeff }}</span>
            </div>
            <div class="char-portrait">
              <img src="/images/thor.png" alt="Thor" />
              <span>{{ t.s1_label_thor }}</span>
            </div>
          </div>
          <p class="eyebrow origin-fg">{{ t.s1_eyebrow }}</p>
          <h2 class="massive-text origin-fg">{{ t.s1_h }}</h2>
          <p class="story-text delay-1 origin-fg" v-html="t.s1_p"></p>
        </div>

        <!-- 2: Word burst -->
        <div v-else-if="currentSlide === 2" class="slide center-align" key="s2">
          <p class="eyebrow">{{ t.s2_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s2_name }}</h2>
          <div class="name-burst delay-1">
            <span
              v-for="(word, i) in t.s2_words"
              :key="i"
              class="burst-word"
              :class="{ 'highlight-bubble': t.s2_highlighted.includes(i) }"
            >{{ word }}</span>
          </div>
        </div>

        <!-- 3: Designer -->
        <div v-else-if="currentSlide === 3" class="slide center-align" key="s3">
          <p class="eyebrow">{{ t.s3_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s3_h1 }}</h2>
          <h2 class="massive-text delay-1">{{ t.s3_h2 }}</h2>
          <h2 class="massive-text delay-2">{{ t.s3_h3 }}</h2>
          <div class="logo-showcase delay-3">
            <img src="/images/logoTeal.png" alt="Logo she made me" />
          </div>
          <p class="story-text delay-4" v-html="t.s3_p"></p>
        </div>

        <!-- 4: Days together -->
        <div v-else-if="currentSlide === 4" class="slide center-align" key="s4">
          <p class="eyebrow">{{ t.s4_eyebrow }}</p>
          <div class="stat-box">
            <span class="number">{{ daysTogether }}</span>
            <span class="label">{{ t.s4_label }}</span>
          </div>
          <h3 class="highlight-text delay-1">{{ t.s4_highlight }}</h3>
          <p class="story-text delay-2">{{ t.s4_sub }}</p>
        </div>

        <!-- 5: Tiki Tiki -->
        <div v-else-if="currentSlide === 5" class="slide center-align" key="s5">
          <p class="eyebrow">{{ t.s5_eyebrow }}</p>
          <div class="playlist-card delay-1">
            <div class="album-art"><span style="font-size: 2rem;">🎵</span></div>
            <div class="track-info">
              <div class="track-title">Tiki Tiki (slowed)</div>
              <div class="track-artist">{{ t.s5_artist }}</div>
            </div>
          </div>
          <h3 class="highlight-text delay-2">{{ t.s5_highlight }}</h3>
        </div>

        <!-- 6: TLOU -->
        <div v-else-if="currentSlide === 6" class="slide center-align" key="s6">
          <p class="eyebrow">{{ t.s7_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s7_h }}</h2>
          <p class="story-text delay-1" v-html="t.s7_p"></p>
        </div>

        <!-- 7: Vecna joke -->
        <div v-else-if="currentSlide === 7" class="slide center-align" key="s7">
          <p class="eyebrow">{{ t.s8_eyebrow }}</p>
          <h1 class="block-text">Vecna.</h1>
          <p class="story-text delay-1" v-html="t.s8_p"></p>
          <h3 class="highlight-text delay-2">{{ t.s8_highlight }}</h3>
        </div>

        <!-- 8: Achievements -->
        <div v-else-if="currentSlide === 8" class="slide" key="s8">
          <p class="eyebrow">{{ t.s9_eyebrow }}</p>
          <div class="achievement-grid">
            <div
              v-for="(ach, i) in t.s9_achievements"
              :key="i"
              class="achievement"
              :class="`delay-${i + 1}`"
            >
              <div class="ach-icon">{{ ach.icon }}</div>
              <div class="ach-title">{{ ach.title }}</div>
              <div class="ach-desc">{{ ach.desc }}</div>
            </div>
          </div>
        </div>

        <!-- 9: Blackpink -->
        <div v-else-if="currentSlide === 9" class="slide center-align" key="s9">
          <p class="eyebrow">{{ t.s6_eyebrow }}</p>
          <h1 class="block-text">BLACKPINK</h1>
          <img src="/images/rosegif.gif" alt="Rosé" class="rose-gif delay-1" />
          <h2 class="highlight-text delay-2">{{ t.s6_highlight }}</h2>
          <p class="story-text delay-3" v-html="t.s6_p"></p>
        </div>

        <!-- 10: Pets -->
        <div v-else-if="currentSlide === 10" class="slide center-align" key="s10">
          <p class="eyebrow">{{ t.s10_eyebrow }}</p>
          <div class="pet-row delay-1">
            <div v-for="(pet, i) in t.s10_pets" :key="i" class="pet-card">
              <div class="pet-emoji">{{ pet.emoji }}</div>
              <div class="pet-name">{{ pet.name }}</div>
              <div class="pet-desc">{{ pet.desc }}</div>
            </div>
          </div>
          <p class="story-text delay-2" v-html="t.s10_p"></p>
        </div>

        <!-- 11: Cooking -->
        <div v-else-if="currentSlide === 11" class="slide center-align" key="s11">
          <p class="eyebrow">{{ t.s11_eyebrow }}</p>
          <div class="giant-emoji delay-1">🍳</div>
          <h2 class="massive-text delay-2">{{ t.s11_h }}</h2>
          <p class="story-text delay-3" v-html="t.s11_p"></p>
        </div>

        <!-- 12: Russian lessons -->
        <div v-else-if="currentSlide === 12" class="slide center-align" key="s12">
          <p class="eyebrow">{{ t.s12_eyebrow }}</p>
          <div class="giant-emoji delay-1">🤐</div>
          <h2 class="massive-text delay-2">{{ t.s12_h }}</h2>
          <p class="story-text delay-3" v-html="t.s12_p"></p>
        </div>

        <!-- 13: Norwegian movie -->
        <div v-else-if="currentSlide === 13" class="slide center-align" key="s13">
          <p class="eyebrow">{{ t.s14_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s14_h }}</h2>
          <p class="story-text delay-1" v-html="t.s14_p"></p>
        </div>

        <!-- 14: The Ring -->
        <div v-else-if="currentSlide === 14" class="slide center-align" key="s14">
          <p class="eyebrow">{{ t.s15_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s15_h }}</h2>
          <p class="story-text delay-1" v-html="t.s15_p"></p>
          <h3 class="highlight-text delay-2">{{ t.s15_highlight }}</h3>
        </div>

        <!-- 15: Discord calls -->
        <div v-else-if="currentSlide === 15" class="slide center-align" key="s15">
          <p class="eyebrow">{{ t.s16_eyebrow }}</p>
          <div class="stat-box">
            <span class="number">12+</span>
            <span class="label">{{ t.s16_label }}</span>
          </div>
          <p class="story-text delay-1" v-html="t.s16_p"></p>
        </div>

        <!-- 16: Style -->
        <div v-else-if="currentSlide === 16" class="slide center-align" key="s16">
          <p class="eyebrow">{{ t.s17_eyebrow }}</p>
          <h2 class="massive-text">{{ t.s17_h1 }}</h2>
          <h2 class="massive-text delay-1">{{ t.s17_h2 }}</h2>
          <p class="story-text delay-2" v-html="t.s17_p"></p>
        </div>

        <!-- 17: Laugh -->
        <div v-else-if="currentSlide === 17" class="slide center-align" key="s17">
          <p class="eyebrow">{{ t.s18_eyebrow }}</p>
          <div class="giant-emoji delay-1">😂</div>
          <h2 class="massive-text delay-2">{{ t.s18_h }}</h2>
          <p class="story-text delay-3" v-html="t.s18_p"></p>
        </div>

        <!-- 18: Cookie -->
        <div v-else-if="currentSlide === 18" class="slide center-align" key="s18">
          <p class="eyebrow">{{ t.s19_eyebrow }}</p>
          <div class="giant-emoji delay-1">🍪</div>
          <h2 class="massive-text delay-2">{{ t.s19_h }}</h2>
          <p class="story-text delay-3" v-html="t.s19_p"></p>
        </div>

        <!-- 19: Names -->
        <div v-else-if="currentSlide === 19" class="slide center-align" key="s19">
          <p class="eyebrow">{{ t.s20_eyebrow }}</p>
          <div class="names-box">
            <div class="name-card delay-1">
              <div class="name-label">{{ t.s20_label1 }}</div>
              <div class="name-value">{{ t.s20_name1 }}</div>
            </div>
            <div class="name-card delay-2">
              <div class="name-label">{{ t.s20_label2 }}</div>
              <div class="name-value">{{ t.s20_name2 }}</div>
            </div>
          </div>
          <p class="story-text delay-3" v-html="t.s20_p"></p>
        </div>

        <!-- 20: Distance -->
        <div v-else-if="currentSlide === 20" class="slide center-align" key="s20">
          <p class="eyebrow">{{ t.s21_eyebrow }}</p>
          <h1 class="block-text">{{ t.s21_from }}</h1>
          <h1 class="block-text highlight">➜</h1>
          <h1 class="block-text">{{ t.s21_to }}</h1>
          <p class="story-text delay-1" v-html="t.s21_p"></p>
        </div>

        <!-- 21: About You -->
        <div v-else-if="currentSlide === 21" class="slide center-align" key="s21">
          <p class="eyebrow">{{ t.s22_eyebrow }}</p>
          <h2 class="massive-text delay-1">{{ t.s22_h }}</h2>
          <p class="story-text delay-2" v-html="t.s22_p"></p>
        </div>

        <!-- 22: Future -->
        <div v-else-if="currentSlide === 22" class="slide center-align" key="s22">
          <p class="eyebrow">{{ t.s23_eyebrow }}</p>
          <div class="future-list">
            <div
              v-for="(item, i) in t.s23_items"
              :key="i"
              class="future-item"
              :class="`delay-${i + 1}`"
            >{{ item }}</div>
          </div>
          <p class="story-text delay-4" v-html="t.s23_p"></p>
        </div>

        <!-- 23: Age reveal -->
        <div v-else-if="currentSlide === 23" class="slide center-align" key="s23">
          <p class="eyebrow">{{ t.s24_eyebrow }}</p>
          <div class="age-reveal delay-1">
            <span class="age-number">21</span>
          </div>
          <p class="story-text delay-2" v-html="t.s24_p"></p>
        </div>

        <!-- 24: Diesel bag -->
        <div v-else-if="currentSlide === 24" class="slide center-align" key="s_bag">
          <p class="eyebrow">{{ t.sbag_eyebrow }}</p>
          <img src="/images/dieselbag.png" alt="Diesel bag" class="bag-img delay-1" />
          <h2 class="massive-text delay-2">{{ t.sbag_h }}</h2>
        </div>

        <!-- 25: Finale -->
        <div v-else-if="currentSlide === 25" class="slide center-align" key="s24">
          <h1 class="neon-pop">{{ t.s25_h1 }}</h1>
          <h1 class="neon-pop">{{ t.s25_h2 }}</h1>
          <h1 class="neon-pop highlight" style="font-size: clamp(2.5rem, 8vw, 4.5rem); margin-top: 0.5rem;">{{ t.s25_h3 }}</h1>
          <p class="final-message delay-1" v-html="t.s25_p"></p>
          <button class="restart-btn delay-2" @click.stop="restart">{{ t.restart_btn }}</button>
        </div>

      </Transition>

      <div class="tap-hint">{{ t.tap_hint }}</div>
    </div>
  </div>
</template>

<script setup>
definePageMeta({ layout: false })

// ── Auth ──
const user = useSupabaseUser()
const authLoading = ref(true)
const isAuthorized = computed(() => !!user.value)
watch(user, () => { authLoading.value = false }, { immediate: true })

// ── Language ──
const lang = ref('en')
const toggleLang = () => { lang.value = lang.value === 'en' ? 'ru' : 'en' }

const translations = {
  en: {
    start_title: 'Your Birthday Wrapped',
    start_sub: 'A look back at everything since we met.',
    start_btn: 'Tap to Unwrap 🎵',
    start_headphones: '🎧 Put your headphones on first',
    tap_hint: 'Tap right to continue, left to go back',
    restart_btn: 'Watch Again ↺',

    s0_eyebrow: 'Happy Birthday',
    s0_h: 'This is for you, Anya.',
    s0_p: 'I made every slide for you.<br>Hope it makes you smile. ❤️',

    s1_eyebrow: 'How It Started',
    s1_h: 'October 2025.',
    s1_label_jeff: 'You',
    s1_label_thor: 'Me',
    s1_p: 'You were Jeff. I was Thor.<br>I whopped your ass, added you as a friend —<br>and somehow you became my duo.<br>Best decision I ever made. 🎮',

    s2_eyebrow: 'Every word when I hear your name',
    s2_name: 'Anya.',
    s2_words: ['Fierce', 'Gorgeous', 'Intelligent', 'Cute', 'Energetic', 'Nerdy', 'Classy', 'Kind', 'Beautiful', 'Goofball', 'Sassy', 'Love'],
    s2_highlighted: [1, 4, 8],

    s3_eyebrow: 'What You Do',
    s3_h1: 'Graphic Designer.',
    s3_h2: 'Brand Builder.',
    s3_h3: 'Future Boss.',
    s3_p: 'You made me this logo, Anya.<br>And I flex it to everyone. Every single person.<br>I can\'t stop. I won\'t stop.',

    s4_eyebrow: 'Let\'s look at the numbers',
    s4_label: 'Days since October 11th',
    s4_highlight: 'And I\'ve loved every single one.',
    s4_sub: 'The ones we didn\'t spend together though? Not a fan.',

    s5_eyebrow: 'Your #1 Song',
    s5_artist: 'Qmiir & Salima Chica',
    s5_highlight: 'On repeat. As it should be.',

    s6_eyebrow: 'Your Girls',
    s6_highlight: 'Especially Rosé.',
    s6_p: 'Good taste runs deep.<br>You know a queen when you see one.',

    s7_eyebrow: 'Your Favorite Story',
    s7_h: 'Ellie & Joel.',
    s7_p: 'You love stories about loyalty,<br>about love that doesn\'t give up on people.<br>Also Pedro Pascal. Let\'s be honest.',

    s8_eyebrow: 'Your Type Apparently',
    s8_p: 'Tall. Pale. Literally the villain of the show.<br>I get it, I get it.<br>I\'m not saying anything. Zero percent jealous.',
    s8_highlight: 'No comment. Absolutely no comment.',

    s9_eyebrow: 'Achievements Unlocked',
    s9_achievements: [
      { icon: '🎨', title: 'Creative Director', desc: 'You make designs that just hit' },
      { icon: '👑', title: 'Future Boss', desc: 'Your own terms, always' },
      { icon: '🍳', title: 'Master Chef', desc: 'You can actually cook' },
      { icon: '❤️', title: 'Stole My Heart', desc: 'No contest. No rematch.' },
    ],

    s10_eyebrow: 'The Chaotic Duo',
    s10_pets: [
      { emoji: '🐀', name: 'Lutic', desc: 'Professionally unhinged' },
      { emoji: '🐱', name: 'Simen', desc: 'Just as bad' },
    ],
    s10_p: 'Two little disasters.<br>You love them both unconditionally.<br>You spent your first paycheck on a bigger cage for Lutic.<br>That tells me everything about you, Anya.',

    s11_eyebrow: 'You Can Actually Cook',
    s11_h: 'Chef mode unlocked.',
    s11_p: 'I\'ve never tasted a single thing you\'ve made.<br>Not one bite. Distance is criminal for this.<br>But I don\'t need to taste it to know it\'s good —<br>I can just tell. 😭',

    s12_eyebrow: 'Russian Lessons Vol. 1',
    s12_h: 'You taught me Russian.',
    s12_p: 'Words I won\'t be mentioning here.<br>Let\'s just say the curriculum was... creative. 😇',


    s14_eyebrow: 'Movie Night Vol. 1',
    s14_h: 'That Norwegian movie.',
    s14_p: 'We never finished it.<br>Still don\'t know how it ends.<br>Classic us.',

    s15_eyebrow: 'Movie Night Vol. 2',
    s15_h: 'The Ring.',
    s15_p: 'The Ring 1 in English. The Ring 2 in Russian.<br>Why Russian? So you could stay awake to take care of Lutic.<br>You sat through a horror film for a rat, Anya.<br>That\'s character. Real character.<br>And I loved seeing it.',
    s15_highlight: 'Lutic knows he got the best mom.',

    s16_eyebrow: 'Time Well Spent',
    s16_label: 'Hours on a single Discord call',
    s16_p: 'Laughing. Playing games. Just existing together.<br>I would do every single one again.',

    s17_eyebrow: 'Your Style',
    s17_h1: 'Whatever you wear',
    s17_h2: 'looks incredible on you.',
    s17_p: 'You have a way of pulling off anything, Anya.<br>Effortless. Annoying.<br>I love it.',

    s18_eyebrow: 'My Favourite Things About You',
    s18_h: 'Your voice.',
    s18_p: 'The way you take care of everyone around you.<br>The way you sing — same song, ten times in a row,<br>like it never gets old.<br>It never does. You have a beautiful voice, Anya.',

    s19_eyebrow: 'The Little Things',
    s19_h: '"I\'m eating a cookie."',
    s19_p: 'You say it and I completely melt.<br>I don\'t know how to explain it.<br>It just makes me beyond happy.',

    s20_eyebrow: 'Names',
    s20_label1: 'You call me',
    s20_name1: 'Samiri',
    s20_label2: 'I call you',
    s20_name2: 'My Sushi 🍣',
    s20_p: 'You\'re the only one who calls me that.<br>And I love you for it.',

    s21_eyebrow: 'The Distance',
    s21_from: 'Norway',
    s21_to: 'Russia',
    s21_p: 'Miles apart.<br>But you\'re the closest person to my heart.',

    s22_eyebrow: 'About You',
    s22_h: 'You know your worth.',
    s22_p: 'Talented. Beautiful. Fierce. Proud.<br>You own every room you walk into.<br>You always have, Anya.',

    s23_eyebrow: 'What\'s Coming',
    s23_items: ['✈️  A vacation with your mom', '👑  Your own design empire', '🌍  A future where you thrive'],
    s23_p: '21 is just the beginning.<br>You\'re only getting started, Anya.',

    s24_eyebrow: 'The Big Number',
    s24_p: 'The year you become your own boss.<br>The year the world finds out who Anya really is.',

    sbag_eyebrow: 'Oh, and one more thing.',
    sbag_h: 'Who got you this bag? 😊❤️',

    s25_h1: 'HAPPY',
    s25_h2: 'BIRTHDAY',
    s25_h3: 'SUSHI 🍣',
    s25_p: 'No amount of words could ever do you justice.<br>You are the only girl in the world. ❤️',
  },

  ru: {
    start_title: 'Твой День Рождения Wrapped',
    start_sub: 'Взгляд на всё, что было с тех пор, как мы встретились.',
    start_btn: 'Нажми, чтобы открыть 🎵',
    start_headphones: '🎧 Сначала надень наушники',
    tap_hint: 'Нажми вправо — дальше, влево — назад',
    restart_btn: 'Посмотреть снова ↺',

    s0_eyebrow: 'С Днём Рождения',
    s0_h: 'Это для тебя, Аня.',
    s0_p: 'Я сделал каждый слайд для тебя.<br>Надеюсь, ты улыбнёшься. ❤️',

    s1_eyebrow: 'Как всё началось',
    s1_h: 'Октябрь 2025.',
    s1_label_jeff: 'Ты',
    s1_label_thor: 'Я',
    s1_p: 'Ты была Jeff. Я был Thor.<br>Я надрал тебе задницу, добавил в друзья —<br>и как-то ты стала моим дуо.<br>Лучшее решение в моей жизни. 🎮',

    s2_eyebrow: 'Каждое слово, когда я слышу твоё имя',
    s2_name: 'Аня.',
    s2_words: ['Дерзкая', 'Потрясающая', 'Умная', 'Милая', 'Энергичная', 'Нёрд', 'Со вкусом', 'Добрая', 'Красивая', 'Чудик', 'Бойкая', 'Любовь'],
    s2_highlighted: [1, 4, 8],

    s3_eyebrow: 'Что ты делаешь',
    s3_h1: 'Графический дизайнер.',
    s3_h2: 'Создатель брендов.',
    s3_h3: 'Будущий босс.',
    s3_p: 'Ты сделала мне этот логотип, Аня.<br>И я показываю его всем. Буквально каждому.<br>Не могу остановиться. И не собираюсь.',

    s4_eyebrow: 'Посмотрим на цифры',
    s4_label: 'Дней с 11 октября',
    s4_highlight: 'И я любил каждый из них.',
    s4_sub: 'Только те, что мы провели порознь — их я не любил.',

    s5_eyebrow: 'Твоя главная песня',
    s5_artist: 'Qmiir & Salima Chica',
    s5_highlight: 'На повторе. Как и должно быть.',

    s6_eyebrow: 'Твои девочки',
    s6_highlight: 'Особенно Rosé.',
    s6_p: 'Хороший вкус — это серьёзно.<br>Ты узнаёшь королеву с первого взгляда.',

    s7_eyebrow: 'Твоя любимая история',
    s7_h: 'Ellie & Joel.',
    s7_p: 'Ты любишь истории о верности,<br>о любви, которая не сдаётся.<br>И Педро Паскаль. Будем честны.',

    s8_eyebrow: 'Твой тип, как выяснилось',
    s8_p: 'Высокий. Бледный. Буквально злодей шоу.<br>Понимаю, понимаю.<br>Ничего не говорю. Ни капли не ревную.',
    s8_highlight: 'Без комментариев. Вообще без комментариев.',

    s9_eyebrow: 'Достижения разблокированы',
    s9_achievements: [
      { icon: '🎨', title: 'Творческий директор', desc: 'Ты делаешь дизайны, которые просто попадают' },
      { icon: '👑', title: 'Будущий босс', desc: 'Всегда на своих условиях' },
      { icon: '🍳', title: 'Мастер-шеф', desc: 'Ты реально умеешь готовить' },
      { icon: '❤️', title: 'Украла моё сердце', desc: 'Без соревнований. Без реванша.' },
    ],

    s10_eyebrow: 'Хаотичное дуо',
    s10_pets: [
      { emoji: '🐀', name: 'Lutic', desc: 'Профессиональный хаос' },
      { emoji: '🐱', name: 'Simen', desc: 'Такой же' },
    ],
    s10_p: 'Два маленьких катаклизма.<br>Ты любишь их обоих безусловно.<br>Ты потратила первую зарплату на клетку для Lutic.<br>Это говорит мне всё о тебе, Аня.',

    s11_eyebrow: 'Ты реально умеешь готовить',
    s11_h: 'Режим шефа активирован.',
    s11_p: 'Я не попробовал ни одного блюда, которое ты приготовила.<br>Ни кусочка. Расстояние — это преступление.<br>Но мне не нужно пробовать, чтобы знать, что вкусно —<br>я просто чувствую. 😭',

    s12_eyebrow: 'Урок русского Vol. 1',
    s12_h: 'Ты учила меня русскому.',
    s12_p: 'Слова, которые я здесь не упомяну.<br>Скажем так — программа была... творческой. 😇',


    s14_eyebrow: 'Киновечер Vol. 1',
    s14_h: 'Тот норвежский фильм.',
    s14_p: 'Мы так и не досмотрели.<br>До сих пор не знаем, чем кончается.<br>Как всегда.',

    s15_eyebrow: 'Киновечер Vol. 2',
    s15_h: 'Звонок.',
    s15_p: 'Звонок 1 — на английском. Звонок 2 — на русском.<br>Почему на русском? Чтобы не заснуть и присмотреть за Lutic.<br>Ты досмотрела ужастик ради крысы, Аня.<br>Вот это характер. Настоящий характер.<br>И я обожал это видеть.',
    s15_highlight: 'Lutic знает, что ему досталась лучшая мама.',

    s16_eyebrow: 'Время потрачено не зря',
    s16_label: 'Часов в одном Discord-звонке',
    s16_p: 'Смеялись. Играли. Просто были вместе.<br>Я бы повторил каждый из них.',

    s17_eyebrow: 'Твой стиль',
    s17_h1: 'Что бы ты ни надела',
    s17_h2: 'на тебе выглядит невероятно.',
    s17_p: 'Ты носишь всё с достоинством, Аня.<br>Без усилий. Это раздражает.<br>Я обожаю это.',

    s18_eyebrow: 'Мои любимые вещи в тебе',
    s18_h: 'Твой голос.',
    s18_p: 'То, как ты заботишься обо всех вокруг.<br>То, как ты поёшь — одну и ту же песню, десять раз подряд,<br>будто она никогда не надоедает.<br>И не надоедает. У тебя красивый голос, Аня.',

    s19_eyebrow: 'Мелочи',
    s19_h: '"Я ем печеньку."',
    s19_p: 'Ты говоришь это, и я таю.<br>Не знаю, как объяснить.<br>Это просто делает меня невероятно счастливым.',

    s20_eyebrow: 'Имена',
    s20_label1: 'Ты зовёшь меня',
    s20_name1: 'Самири',
    s20_label2: 'Я зову тебя',
    s20_name2: 'Моя Суши 🍣',
    s20_p: 'Ты единственная, кто так меня называет.<br>И я люблю тебя за это.',

    s21_eyebrow: 'Расстояние',
    s21_from: 'Норвегия',
    s21_to: 'Россия',
    s21_p: 'Далеко друг от друга.<br>Но ты ближайший человек к моему сердцу.',

    s22_eyebrow: 'О тебе',
    s22_h: 'Ты знаешь себе цену.',
    s22_p: 'Талантливая. Красивая. Дерзкая. Гордая.<br>Ты занимаешь каждое пространство, в которое входишь.<br>И всегда занимала, Аня.',

    s23_eyebrow: 'Что впереди',
    s23_items: ['✈️  Отпуск с мамой', '👑  Твоя дизайн-империя', '🌍  Будущее, где ты процветаешь'],
    s23_p: '21 — это только начало.<br>Ты только начинаешь, Аня.',

    s24_eyebrow: 'Главная цифра',
    s24_p: 'Год, когда ты становишься своим боссом.<br>Год, когда мир узнает, кто такая Аня на самом деле.',

    sbag_eyebrow: 'Ещё кое-что.',
    sbag_h: 'Кто тебе купил эту сумку? 😊❤️',

    s25_h1: 'С ДНЁМ',
    s25_h2: 'РОЖДЕНИЯ',
    s25_h3: 'СУШИ 🍣',
    s25_p: 'Никакие слова не опишут, насколько ты удивительна.<br>Ты единственная в мире. ❤️',
  }
}

const t = computed(() => translations[lang.value])

// ── Slide State ──
const bgMusic = ref(null)
const bpMusic = ref(null)
const dmMusic = ref(null)
const isStarted = ref(false)
const currentSlide = ref(0)
const totalSlides = 26
const slides = Array(totalSlides).fill(0)
const AUTO_ADVANCE_MS = 12000
let autoAdvanceTimer = null

const gradients = [
  'linear-gradient(135deg, #FF00A6, #FF9B00)',
  'linear-gradient(135deg, #4A00E0, #8E2DE2)',
  'linear-gradient(135deg, #00C9FF, #92FE9D)',
  'linear-gradient(135deg, #f12711, #f5af19)',
  'linear-gradient(135deg, #11998e, #38ef7d)',
  'linear-gradient(135deg, #1A2980, #26D0CE)',
  'linear-gradient(135deg, #FF00A6, #4A00E0)',
  'linear-gradient(135deg, #00C9FF, #1A2980)',
  'linear-gradient(135deg, #f5af19, #FF00A6)',
  'linear-gradient(135deg, #38ef7d, #00C9FF)',
  'linear-gradient(135deg, #8E2DE2, #f12711)',
  'linear-gradient(135deg, #26D0CE, #92FE9D)',
  'linear-gradient(135deg, #FF9B00, #f5af19)',
  'linear-gradient(135deg, #4A00E0, #1A2980)',
  'linear-gradient(135deg, #f12711, #FF00A6)',
  'linear-gradient(135deg, #11998e, #1A2980)',
  'linear-gradient(135deg, #8E2DE2, #FF00A6)',
  'linear-gradient(135deg, #00C9FF, #f5af19)',
  'linear-gradient(135deg, #FF00A6, #f12711)',
  'linear-gradient(135deg, #4A00E0, #26D0CE)',
  'linear-gradient(135deg, #1A2980, #FF9B00)',
  'linear-gradient(135deg, #FF00A6, #92FE9D)',
  'linear-gradient(135deg, #f12711, #38ef7d)',
  'linear-gradient(135deg, #8E2DE2, #11998e)',
  'linear-gradient(135deg, #FF9B00, #00C9FF)',
  'linear-gradient(135deg, #f5af19, #4A00E0)'
]

const currentGradient = computed(() => gradients[currentSlide.value])

const startDate = new Date('2025-10-11T00:00:00')
const today = new Date()
const daysTogether = Math.floor((today - startDate) / (1000 * 60 * 60 * 24))

const loadConfetti = () => {
  if (!document.getElementById('confetti-script')) {
    const script = document.createElement('script')
    script.id = 'confetti-script'
    script.src = 'https://cdn.jsdelivr.net/npm/canvas-confetti@1.9.3/dist/confetti.browser.min.js'
    document.head.appendChild(script)
  }
}

onMounted(() => {
  if (bpMusic.value) {
    bpMusic.value.src = "/music/BLACKPINK - 'Kill This Love' MV.mp3"
    bpMusic.value.load()
  }
  if (dmMusic.value) {
    dmMusic.value.src = '/music/Lose My Mind (feat. Doja Cat).mp3'
    dmMusic.value.load()
  }
  loadConfetti()
  window.addEventListener('keydown', handleKey)
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKey)
  clearTimeout(autoAdvanceTimer)
})

const resetAutoAdvance = () => {
  clearTimeout(autoAdvanceTimer)
  if (!isStarted.value) return
  if (currentSlide.value >= totalSlides - 1) return
  autoAdvanceTimer = setTimeout(() => {
    currentSlide.value++
    if (currentSlide.value === totalSlides - 1) triggerConfetti()
    resetAutoAdvance()
  }, AUTO_ADVANCE_MS)
}

const BLACKPINK_SLIDE = 9
const DOJA_SLIDE = 21

watch(currentSlide, (slide) => {
  resetAutoAdvance()
  if (!isStarted.value) return
  if (slide === BLACKPINK_SLIDE - 2) {
    fadeTo(bgMusic.value, 0.38, 2500)
  } else if (slide === BLACKPINK_SLIDE - 1) {
    fadeTo(bgMusic.value, 0.12, 3000)
  } else if (slide === BLACKPINK_SLIDE) {
    bgMusic.value?.pause()
    bgMusic.value && (bgMusic.value.currentTime = 0)
    if (bpMusic.value) {
      bpMusic.value.currentTime = 0.5
      fadeIn(bpMusic.value, 0.72, 3500)
      bpMusic.value.play().catch(() => {})
    }
  } else if (slide === DOJA_SLIDE - 2) {
    fadeTo(bpMusic.value, 0.38, 2500)
  } else if (slide === DOJA_SLIDE - 1) {
    fadeTo(bpMusic.value, 0.12, 3000)
  } else if (slide === DOJA_SLIDE) {
    bpMusic.value?.pause()
    bpMusic.value && (bpMusic.value.currentTime = 0)
    if (dmMusic.value) {
      dmMusic.value.currentTime = 0
      fadeIn(dmMusic.value, 0.72, 3500)
      dmMusic.value.play().catch(() => {})
    }
  }
})

watch(isStarted, (started) => { if (started) resetAutoAdvance() })

const fadeTo = (audio, target, duration = 2000) => {
  const startVol = audio.volume
  const diff = target - startVol
  const steps = 50
  const stepTime = duration / steps
  let step = 0
  const tick = setInterval(() => {
    step++
    audio.volume = Math.min(Math.max(startVol + (diff * step / steps), 0), 1)
    if (step >= steps) clearInterval(tick)
  }, stepTime)
}

const fadeIn = (audio, target = 0.72, duration = 5000) => {
  audio.volume = 0.01
  fadeTo(audio, target, duration)
}

const startExperience = () => {
  isStarted.value = true
  if (bgMusic.value) {
    bgMusic.value.play().catch(() => {})
    fadeIn(bgMusic.value)
  }
}

const nextSlide = () => {
  if (currentSlide.value < totalSlides - 1) {
    currentSlide.value++
    if (currentSlide.value === totalSlides - 1) triggerConfetti()
  }
}

const prevSlide = () => { if (currentSlide.value > 0) currentSlide.value-- }

const handleTap = (e) => {
  if (e.clientX > window.innerWidth / 2) nextSlide()
  else prevSlide()
}

const handleKey = (e) => {
  if (e.key === 'ArrowRight' || e.key === ' ') { e.preventDefault(); nextSlide() }
  if (e.key === 'ArrowLeft') { e.preventDefault(); prevSlide() }
}

const restart = () => {
  bpMusic.value?.pause()
  bpMusic.value && (bpMusic.value.currentTime = 0)
  dmMusic.value?.pause()
  dmMusic.value && (dmMusic.value.currentTime = 0)
  bgMusic.value && (bgMusic.value.currentTime = 0)
  if (bgMusic.value) { bgMusic.value.play().catch(() => {}); fadeIn(bgMusic.value, 0.72, 5000) }
  currentSlide.value = 0
  resetAutoAdvance()
}

const triggerConfetti = () => {
  if (window.confetti) {
    const end = Date.now() + 4000
    const frame = () => {
      window.confetti({ particleCount: 8, angle: 60, spread: 55, origin: { x: 0 }, colors: ['#ff00a6', '#00c9ff', '#ffffff', '#f5af19', '#ff9b00'] })
      window.confetti({ particleCount: 8, angle: 120, spread: 55, origin: { x: 1 }, colors: ['#ff00a6', '#00c9ff', '#ffffff', '#f5af19', '#ff9b00'] })
      window.confetti({ particleCount: 5, spread: 100, origin: { y: 0.6 }, colors: ['#ff00a6', '#00c9ff', '#ffffff', '#f5af19'] })
      if (Date.now() < end) requestAnimationFrame(frame)
    }
    frame()
  }
}
</script>

<style scoped>
* { box-sizing: border-box; margin: 0; padding: 0; }

:root { --font-main: 'Helvetica Neue', Helvetica, Arial, sans-serif; }

.gate {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #121212;
  color: white;
  text-align: center;
  font-family: var(--font-main);
}

.gate-btn {
  margin-top: 1rem;
  padding: 0.75rem 2rem;
  background: #1DB954;
  color: black;
  font-weight: bold;
  border-radius: 999px;
  text-decoration: none;
}

.wrapped-app {
  width: 100vw;
  height: 100vh;
  overflow: hidden;
  background: #000;
  color: white;
  font-family: var(--font-main);
  position: relative;
  touch-action: manipulation;
}

/* Start Screen */
.start-screen {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  background: #121212;
  z-index: 50;
  cursor: pointer;
  overflow: hidden;
}

.start-content {
  text-align: center;
  z-index: 2;
  padding: 2rem;
}

.start-content h1 {
  font-size: clamp(2.5rem, 8vw, 4rem);
  font-weight: 900;
  letter-spacing: -1px;
  margin-bottom: 0.5rem;
}

.start-content p {
  font-size: 1.2rem;
  color: #b3b3b3;
  margin-bottom: 2.5rem;
}

.play-btn {
  background: #fff;
  color: #000;
  border: none;
  padding: 1rem 2.5rem;
  font-size: 1.2rem;
  font-weight: bold;
  border-radius: 999px;
  cursor: pointer;
  transition: transform 0.2s, background 0.2s;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.3);
}

.play-btn:hover { transform: scale(1.05); background: #1DB954; color: #fff; }

.headphones-hint {
  margin-top: 1.25rem;
  font-size: 0.95rem;
  color: rgba(255, 255, 255, 0.5);
  letter-spacing: 0.5px;
}

/* Lang Toggle */
.lang-toggle {
  background: rgba(0, 0, 0, 0.5);
  color: white;
  border: 1.5px solid rgba(255, 255, 255, 0.35);
  border-radius: 999px;
  padding: 0.3rem 0.9rem;
  font-size: 0.85rem;
  font-weight: 700;
  letter-spacing: 1px;
  cursor: pointer;
  backdrop-filter: blur(8px);
  transition: background 0.2s;
  z-index: 20;
}

.lang-toggle:hover { background: rgba(255, 255, 255, 0.2); }

.start-lang {
  position: absolute;
  top: 1.5rem;
  right: 1.5rem;
}

.story-lang {
  position: absolute;
  top: 3.5rem;
  right: 1.5rem;
}

/* Blobs */
.blob {
  position: absolute;
  filter: blur(80px);
  z-index: 1;
  border-radius: 50%;
  opacity: 0.6;
}

.blob-1 {
  width: 300px; height: 300px;
  background: #FF00A6;
  top: -50px; left: -50px;
  animation: float 8s infinite alternate ease-in-out;
}

.blob-2 {
  width: 400px; height: 400px;
  background: #4A00E0;
  bottom: -100px; right: -50px;
  animation: float 10s infinite alternate-reverse ease-in-out;
}

@keyframes float {
  0% { transform: translate(0, 0); }
  100% { transform: translate(30px, 50px); }
}

/* Story Interface */
.story-container {
  position: absolute;
  inset: 0;
  display: flex;
  flex-direction: column;
  padding: 1.5rem;
  transition: background 0.6s ease;
  user-select: none;
}

.story-progress {
  display: flex;
  gap: 0.5rem;
  margin-top: 0.5rem;
  z-index: 10;
}

.dash-track {
  flex: 1;
  height: 4px;
  background: rgba(255, 255, 255, 0.3);
  border-radius: 2px;
  overflow: hidden;
}

.dash-fill {
  height: 100%;
  background: #fff;
  width: 0%;
  transition: width 0.3s ease;
}

.dash-fill.filled { width: 100%; }

.dash-fill.active {
  width: 100%;
  animation: progressFill 12s linear forwards;
}

@keyframes progressFill {
  0% { width: 0%; }
  100% { width: 100%; }
}

.tap-hint {
  position: absolute;
  bottom: 2rem;
  left: 0;
  width: 100%;
  text-align: center;
  font-size: 0.8rem;
  color: rgba(255, 255, 255, 0.5);
  letter-spacing: 1px;
  pointer-events: none;
}

/* Slide base */
.slide {
  flex: 1;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 1rem;
  z-index: 5;
  position: relative;
}

.center-align { align-items: center; text-align: center; }

.eyebrow {
  font-size: 1rem;
  text-transform: uppercase;
  letter-spacing: 2px;
  font-weight: bold;
  opacity: 0.8;
  margin-bottom: 2rem;
}

.massive-text {
  font-size: clamp(3rem, 10vw, 5rem);
  font-weight: 900;
  line-height: 1.1;
  letter-spacing: -2px;
  margin-bottom: 1rem;
}

.story-text {
  font-size: clamp(1.1rem, 4vw, 1.5rem);
  font-weight: 500;
  opacity: 0.95;
  line-height: 1.5;
  margin-top: 1rem;
}

.block-text {
  font-size: clamp(3.5rem, 12vw, 6rem);
  font-weight: 900;
  line-height: 0.9;
  letter-spacing: -3px;
  text-transform: uppercase;
}

.highlight {
  color: #FFE600;
  text-shadow: 0 4px 20px rgba(255, 230, 0, 0.4);
}

.highlight-text {
  font-size: clamp(1.8rem, 6vw, 2.5rem);
  font-weight: 800;
  margin-top: 2rem;
  background: #fff;
  color: #000;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  display: inline-block;
  transform: rotate(-2deg);
}

/* Stat Box */
.stat-box {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: rgba(0, 0, 0, 0.3);
  padding: 3rem 2rem;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
  backdrop-filter: blur(10px);
}

.stat-box .number {
  font-size: clamp(4rem, 15vw, 7rem);
  font-weight: 900;
  letter-spacing: -3px;
  line-height: 1;
}

.stat-box .label {
  font-size: 1.2rem;
  font-weight: bold;
  margin-top: 0.5rem;
  color: #FFE600;
}

/* Playlist Card */
.playlist-card {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  padding: 1.5rem 2rem;
  backdrop-filter: blur(8px);
}

.album-art {
  width: 80px; height: 80px;
  background: linear-gradient(135deg, #FF00A6, #4A00E0);
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.track-title { font-size: 1.8rem; font-weight: 800; }
.track-artist { font-size: 1.1rem; opacity: 0.8; margin-top: 0.25rem; }

/* Achievements */
.achievement-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.achievement {
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  padding: 1.5rem 1rem;
  text-align: center;
  backdrop-filter: blur(8px);
}

.ach-icon { font-size: 2rem; margin-bottom: 0.5rem; }
.ach-title { font-size: 1.1rem; font-weight: 800; margin-bottom: 0.25rem; }
.ach-desc { font-size: 0.85rem; opacity: 0.8; }

/* Pets */
.pet-row {
  display: flex;
  gap: 2rem;
  justify-content: center;
  margin: 1rem 0;
}

.pet-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 20px;
  padding: 1.5rem 2rem;
  backdrop-filter: blur(8px);
  gap: 0.5rem;
}

.pet-emoji { font-size: 3rem; }
.pet-name { font-size: 1.4rem; font-weight: 900; }
.pet-desc { font-size: 0.9rem; opacity: 0.7; text-transform: uppercase; letter-spacing: 1px; }

/* Opener image */
.opener-img {
  height: clamp(100px, 20vw, 160px);
  width: auto;
  object-fit: contain;
  margin-bottom: 0.5rem;
  filter: drop-shadow(0 8px 24px rgba(0,0,0,0.4));
}

/* Diesel bag */
.bag-img {
  height: clamp(160px, 35vw, 280px);
  width: auto;
  object-fit: contain;
  border-radius: 16px;
  margin: 0.75rem 0;
  filter: drop-shadow(0 12px 30px rgba(0,0,0,0.5));
}

/* Rosé gif */
.rose-gif {
  height: clamp(80px, 18vw, 130px);
  width: auto;
  object-fit: contain;
  border-radius: 12px;
  margin: 0.5rem 0;
  box-shadow: 0 8px 24px rgba(0,0,0,0.4);
}

/* Giant Emoji */
.giant-emoji {
  font-size: clamp(4rem, 15vw, 7rem);
  line-height: 1;
  margin-bottom: 1rem;
}

/* Word Cloud */
.word-cloud {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 1rem;
  max-width: 500px;
}

.word-bubble {
  font-size: clamp(1.2rem, 4vw, 1.8rem);
  font-weight: 800;
  background: rgba(0, 0, 0, 0.4);
  padding: 0.75rem 1.5rem;
  border-radius: 999px;
  border: 2px solid rgba(255, 255, 255, 0.2);
}

.highlight-bubble { background: #FFE600; color: #000; border-color: #FFE600; }

/* Name Burst */
.name-burst {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  gap: 0.6rem;
  max-width: 520px;
  margin-top: 1rem;
}

.burst-word {
  font-size: clamp(1rem, 3.5vw, 1.4rem);
  font-weight: 800;
  background: rgba(0, 0, 0, 0.35);
  padding: 0.5rem 1.1rem;
  border-radius: 999px;
  border: 2px solid rgba(255, 255, 255, 0.2);
}

/* Matchup */
.matchup {
  position: absolute;
  inset: 0;
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  padding: 0 1rem 3.5rem;
  z-index: 0;
  pointer-events: none;
}

.char-portrait {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.5rem;
}

.char-portrait img {
  height: 200px;
  width: auto;
}

.jeff-img {
  margin-top: 2rem;
}

.origin-fg {
  position: relative;
  z-index: 1;
}

.char-portrait span {
  font-size: 1rem;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
}

/* Language Box */
.lang-box {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  font-size: clamp(1.5rem, 5vw, 2.5rem);
  font-weight: 900;
  background: rgba(0, 0, 0, 0.3);
  padding: 2rem 3rem;
  border-radius: 20px;
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Names */
.names-box {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
  width: 100%;
  max-width: 400px;
}

.name-card {
  background: rgba(0, 0, 0, 0.4);
  border: 1px solid rgba(255, 255, 255, 0.15);
  border-radius: 16px;
  padding: 1.5rem;
  text-align: center;
}

.name-label { font-size: 0.9rem; text-transform: uppercase; letter-spacing: 2px; opacity: 0.7; margin-bottom: 0.5rem; }
.name-value { font-size: clamp(1.8rem, 6vw, 2.5rem); font-weight: 900; }

/* Fall List */
.fall-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 100%;
  max-width: 450px;
}

.fall-item {
  font-size: clamp(1.2rem, 4vw, 1.6rem);
  font-weight: 700;
  background: rgba(0, 0, 0, 0.4);
  padding: 1rem 1.5rem;
  border-radius: 12px;
  text-align: center;
}

/* Logo */
.logo-showcase {
  background: rgba(0, 0, 0, 0.4);
  border-radius: 12px;
  padding: 1rem;
  display: flex;
  justify-content: center;
  align-items: center;
}

.logo-showcase img { max-width: 200px; max-height: 120px; object-fit: contain; }

/* Future List */
.future-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  width: 100%;
  max-width: 450px;
  margin: 1rem 0;
}

.future-item {
  font-size: clamp(1.1rem, 4vw, 1.5rem);
  font-weight: 700;
  background: rgba(0, 0, 0, 0.4);
  padding: 1rem 1.5rem;
  border-radius: 12px;
  text-align: left;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

/* Age Reveal */
.age-reveal { display: flex; align-items: center; justify-content: center; }

.age-number {
  font-size: clamp(8rem, 25vw, 14rem);
  font-weight: 900;
  line-height: 1;
  letter-spacing: -8px;
  background: linear-gradient(135deg, #FFE600, #FF00A6);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

/* Finale */
.neon-pop {
  font-size: clamp(3.5rem, 12vw, 6rem);
  font-weight: 900;
  line-height: 1;
  color: white;
  text-shadow: 0 0 20px rgba(255, 255, 255, 0.8);
}

.final-message { margin-top: 2rem; font-size: 1.5rem; font-weight: 600; line-height: 1.5; }

.restart-btn {
  margin-top: 2rem;
  padding: 0.75rem 2rem;
  background: #fff;
  color: #000;
  border: none;
  border-radius: 999px;
  font-size: 1rem;
  font-weight: bold;
  cursor: pointer;
  transition: transform 0.2s;
}

.restart-btn:hover { transform: scale(1.05); }

/* Transitions */
.slide-up-enter-active,
.slide-up-leave-active {
  transition: all 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}

.slide-up-enter-from {
  opacity: 0;
  transform: translateY(40px) scale(0.95);
}

.slide-up-leave-to {
  opacity: 0;
  transform: translateY(-40px) scale(1.05);
}

.delay-1 { animation: fadeUpIn 0.6s ease forwards 0.4s; opacity: 0; }
.delay-2 { animation: fadeUpIn 0.6s ease forwards 0.6s; opacity: 0; }
.delay-3 { animation: fadeUpIn 0.6s ease forwards 0.8s; opacity: 0; }
.delay-4 { animation: fadeUpIn 0.6s ease forwards 1.0s; opacity: 0; }

@keyframes fadeUpIn {
  from { opacity: 0; transform: translateY(20px); }
  to { opacity: 1; transform: translateY(0); }
}

@media (max-width: 480px) {
  .achievement-grid { grid-template-columns: 1fr; }
  .playlist-card { flex-direction: column; text-align: center; }
  .pet-row { gap: 1rem; }
  .pet-card { padding: 1rem 1.25rem; }
}
</style>
