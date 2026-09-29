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
    <p v-if="error">ユーザーを取得できませんでした</p>
    <ul v-else>
      <li v-for="user in users" :key="user.id">
        {{ user.name }}（{{ user.email }}）
      </li>
    </ul>
  </div>
</template>