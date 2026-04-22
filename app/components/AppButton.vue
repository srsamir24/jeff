<template>
  <UButton
    :to="to"
    :type="!to ? type : undefined"
    :disabled="disabled || loading"
    :loading="loading"
    :block="fullWidth"
    :color="mappedColor"
    :variant="mappedVariant"
    :size="mappedSize"
    :class="buttonClasses"
    @click="handleClick"
  >
    <template v-if="$slots.iconLeft" #leading>
      <slot name="iconLeft" />
    </template>
    <template v-if="loading" #default>
      <span>{{ loadingText || 'Loading...' }}</span>
    </template>
    <template v-else #default>
      <slot />
    </template>
    <template v-if="$slots.iconRight" #trailing>
      <slot name="iconRight" />
    </template>
  </UButton>
</template>

<script setup>
const props = defineProps({
  to: { type: String, default: '' },
  variant: {
    type: String,
    default: 'primary',
    validator: (value) => ['primary', 'secondary', 'outline', 'ghost', 'danger'].includes(value)
  },
  size: {
    type: String,
    default: 'md',
    validator: (value) => ['sm', 'md', 'lg', 'xl'].includes(value)
  },
  type: { type: String, default: 'button' },
  disabled: { type: Boolean, default: false },
  loading: { type: Boolean, default: false },
  loadingText: { type: String, default: '' },
  fullWidth: { type: Boolean, default: false },
  rounded: {
    type: String,
    default: '3xl',
    validator: (value) => ['sm', 'md', 'lg', 'xl', '2xl', '3xl', 'full'].includes(value)
  }
})

const mappedVariant = computed(() => {
  switch (props.variant) {
    case 'primary': return 'solid'
    case 'secondary': return 'solid'
    case 'outline': return 'outline'
    case 'ghost': return 'ghost'
    case 'danger': return 'solid'
    default: return 'solid'
  }
})

const mappedColor = computed(() => {
  switch (props.variant) {
    case 'primary': return 'primary'
    case 'secondary': return 'secondary'
    case 'outline': return 'primary'
    case 'ghost': return 'neutral'
    case 'danger': return 'error'
    default: return 'primary'
  }
})

const mappedSize = computed(() => props.size)

const buttonClasses = computed(() => {
  const roundedMap = {
    sm: 'rounded-sm',
    md: 'rounded-md',
    lg: 'rounded-lg',
    xl: 'rounded-xl',
    '2xl': 'rounded-2xl',
    '3xl': 'rounded-3xl',
    full: 'rounded-full'
  }
  return roundedMap[props.rounded] || 'rounded-3xl'
})

const emit = defineEmits(['click'])

const handleClick = (event) => {
  if (!props.disabled && !props.loading) {
    emit('click', event)
  }
}
</script>
