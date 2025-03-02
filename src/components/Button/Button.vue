<template>
    <button
      :id="id"
      :type="type"
      :disabled="disabled"
      @click.once="handleClick"
      :class="buttonClass"
    >
      <slot></slot>
    </button>
</template>
  
<script>
export default {
    name: 'Button',
    props: {
        id: {
            type: String,
            default: null
        },
        type: {
            type: String,
            default: 'button'
        },
        disabled: {
            type: Boolean,
            default: false
        },
        buttonClass: {
            type: String,
            default: ''
        }
    },
    methods: {
        handleClick(event) {
            if (this.type !== 'submit') {
                event.preventDefault();
            }

            this.$emit('click', event);
        }
    }
}
</script>

<style lang="scss" scoped>
@use './Button.scss';
</style>