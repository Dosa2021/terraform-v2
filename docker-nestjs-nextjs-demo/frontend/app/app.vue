<script setup lang="ts">
type User = {
  id: number
  name: string
  email: string
  createdAt: string
}
const { data: users, error } = await useFetch<User[]>('/users')
</script>

<template>
  <div>
    <div v-if="error">
      <p>ユーザーを取得できませんでした</p>
      <p>status: {{ error.statusCode }} {{ error.statusMessage }}</p>
      <pre>{{ error.data ?? error.message }}</pre>
    </div>
    <ul v-else>
      <li v-for="user in users" :key="user.id">
        {{ user.name }}（{{ user.email }}）
      </li>
    </ul>
  </div>
</template>