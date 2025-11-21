<template>
  <component
    :is="componentType"
    :to="to"
    :type="!to ? type : undefined"
    :disabled="disabled || loading"
    :class="buttonClasses"
    @click="handleClick"
  >
    <!-- Loading Spinner -->
    <svg
      v-if="loading"
      class="animate-spin h-5 w-5"
      fill="none"
      viewBox="0 0 24 24"
    >
      <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
      <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
    </svg>

    <!-- Icon Left -->
    <span v-if="$slots.iconLeft && !loading" class="flex-shrink-0">
      <slot name="iconLeft" />
    </span>

    <!-- Default Slot (Text) -->
    <span v-if="!loading || loadingText" :class="textClasses">
      <slot>{{ loading && loadingText ? loadingText : '' }}</slot>
    </span>

    <!-- Icon Right -->
    <span v-if="$slots.iconRight && !loading" class="flex-shrink-0">
      <slot name="iconRight" />
    </span>
  </component>
</template>

<script setup>
const props = defineProps({
  to: {
    type: String,
    default: ''
  },
  variant: {
    type: String,
    default: 'primary', // primary, secondary, outline, ghost, danger
    validator: (value) => ['primary', 'secondary', 'outline', 'ghost', 'danger'].includes(value)
  },
  size: {
    type: String,
    default: 'md', // sm, md, lg, xl
    validator: (value) => ['sm', 'md', 'lg', 'xl'].includes(value)
  },
  type: {
    type: String,
    default: 'button'
  },
  disabled: {
    type: Boolean,
    default: false
  },
  loading: {
    type: Boolean,
    default: false
  },
  loadingText: {
    type: String,
    default: ''
  },
  fullWidth: {
    type: Boolean,
    default: false
  },
  rounded: {
    type: String,
    default: '3xl', // sm, md, lg, xl, 2xl, 3xl, full
    validator: (value) => ['sm', 'md', 'lg', 'xl', '2xl', '3xl', 'full'].includes(value)
  }
})

// Determine component type based on 'to' prop
const componentType = computed(() => props.to ? resolveComponent('NuxtLink') : 'button')

const emit = defineEmits(['click'])

const handleClick = (event) => {
  if (!props.disabled && !props.loading) {
    emit('click', event)
  }
}

const baseClasses = computed(() => [
  'group inline-flex items-center justify-center gap-2 sm:gap-3',
  'font-semibold transition-all duration-300',
  'focus:outline-none focus:ring-4 focus:ring-offset-2',
  'cursor-pointer',
  'hover:-translate-y-1 active:scale-95',
  'disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 disabled:hover:translate-y-0',
  props.fullWidth ? 'w-full' : '',
])

const sizeClasses = computed(() => {
  const sizes = {
    sm: 'px-6 py-2.5 text-sm',
    md: 'px-8 py-4 text-base',
    lg: 'px-8 py-4 text-base sm:px-10 sm:py-5 sm:text-lg',
    xl: 'px-10 py-5 text-lg sm:text-xl'
  }
  return sizes[props.size]
})

const roundedClasses = computed(() => {
  const rounded = {
    sm: 'rounded',
    md: 'rounded-lg',
    lg: 'rounded-xl',
    xl: 'rounded-2xl',
    '2xl': 'rounded-2xl',
    '3xl': 'rounded-3xl',
    full: 'rounded-full'
  }
  return rounded[props.rounded]
})

const variantClasses = computed(() => {
  const variants = {
    primary: [
      'bg-blue-purple text-portfolio-white',
      'shadow-lg hover:shadow-2xl',
      'hover:bg-bright-pink',
      'focus:ring-blue-purple/30'
    ].join(' '),

    secondary: [
      'bg-bright-pink text-portfolio-white',
      'shadow-lg',
      'hover:shadow-[0_0_40px_rgba(255,105,180,0.6)]',
      'focus:ring-bright-pink/30'
    ].join(' '),

    outline: [
      'bg-portfolio-white text-blue-purple',
      'border-2 border-light-blue',
      'shadow-lg hover:shadow-2xl',
      'hover:bg-light-blue/20 hover:border-light-blue',
      'focus:ring-light-blue/30'
    ].join(' '),

    ghost: [
      'bg-light-blue/10 text-light-blue',
      'hover:bg-light-blue/20',
      'shadow-md hover:shadow-lg',
      'focus:ring-light-blue/30'
    ].join(' '),

    danger: [
      'bg-bright-pink/10 text-bright-pink',
      'hover:bg-bright-pink hover:text-portfolio-white',
      'shadow-md hover:shadow-xl',
      'focus:ring-bright-pink/30',
      'border border-bright-pink/20 hover:border-bright-pink'
    ].join(' ')
  }
  return variants[props.variant]
})

const textClasses = computed(() => {
  return props.loading ? 'opacity-0' : ''
})

const buttonClasses = computed(() => [
  ...baseClasses.value,
  sizeClasses.value,
  roundedClasses.value,
  variantClasses.value
])
</script>
