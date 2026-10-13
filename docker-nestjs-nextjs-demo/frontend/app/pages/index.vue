<script setup lang="ts">
const stage = ref<HTMLElement | null>(null)
const play = ref(false)

function start() {
  play.value = true
  stage.value?.requestFullscreen()
}
</script>

<template>
  <main class="mx-auto text-center">
    <button type="button" @click="start">
      <NuxtImg
        src="/img/ozaki.jpg"
        width="500"
        alt="尾崎豊"
        class="mx-auto"
      />
    </button>

    <div ref="stage" class="fixed inset-0 bg-black" :class="play ? 'block' : 'hidden'">
      <iframe
        v-if="play"
        class="h-full w-full"
        src="https://www.youtube.com/embed/Bh6atqzUnGQ?autoplay=1&mute=1&playsinline=1"
        title="YouTube video player"
        allow="autoplay; fullscreen; picture-in-picture"
        allowfullscreen
      />
    </div>
  </main>
</template>
