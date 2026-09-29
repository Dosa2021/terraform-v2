# Backend (Hono)

Node: v22.16.0

docker exec -it mysql-container mysql -u testuser -p

```bash
npm install
npm run start:dev
# → http://localhost:8000
```

Docker:

```bash
docker compose up --build backend
```

### ユーザー登録

・マイグレーションファイル作成
cd docker-nestjs-nextjs-demo/backend
npx drizzle-kit generate

・マイグレーション実行
npx drizzle-kit migrate

・マイグレーション実行(強制？)
npx drizzle-kit push


