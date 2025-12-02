# React + TypeScript + Vite

This template provides a minimal setup to get React working in Vite with HMR and some ESLint rules.

Currently, two official plugins are available:

- [@vitejs/plugin-react](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react) uses [Babel](https://babeljs.io/) for Fast Refresh
- [@vitejs/plugin-react-swc](https://github.com/vitejs/vite-plugin-react/blob/main/packages/plugin-react-swc) uses [SWC](https://swc.rs/) for Fast Refresh

## Expanding the ESLint configuration

If you are developing a production application, we recommend updating the configuration to enable type-aware lint rules:

```js
export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...

      // Remove tseslint.configs.recommended and replace with this
      ...tseslint.configs.recommendedTypeChecked,
      // Alternatively, use this for stricter rules
      ...tseslint.configs.strictTypeChecked,
      // Optionally, add this for stylistic rules
      ...tseslint.configs.stylisticTypeChecked,

      // Other configs...
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

You can also install [eslint-plugin-react-x](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-x) and [eslint-plugin-react-dom](https://github.com/Rel1cx/eslint-react/tree/main/packages/plugins/eslint-plugin-react-dom) for React-specific lint rules:

```js
// eslint.config.js
import reactX from 'eslint-plugin-react-x'
import reactDom from 'eslint-plugin-react-dom'

export default tseslint.config([
  globalIgnores(['dist']),
  {
    files: ['**/*.{ts,tsx}'],
    extends: [
      // Other configs...
      // Enable lint rules for React
      reactX.configs['recommended-typescript'],
      // Enable lint rules for React DOM
      reactDom.configs.recommended,
    ],
    languageOptions: {
      parserOptions: {
        project: ['./tsconfig.node.json', './tsconfig.app.json'],
        tsconfigRootDir: import.meta.dirname,
      },
      // other options...
    },
  },
])
```

Deploy k8s

```
# 1. Build Image (beri nama tag :v1)
docker build -t ai-notetaking-fe:v1 .

# 2. Transfer Image dari Docker ke K3s
docker save ai-notetaking-fe:v1 | sudo k3s ctr images import -
```

```
nano fe-deploy.yaml
```

```
# --- DEPLOYMENT ---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ai-note-frontend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ai-note-fe
  template:
    metadata:
      labels:
        app: ai-note-fe
    spec:
      containers:
      - name: web
        image: ai-notetaking-fe:v1  # Image yang baru kita build
        imagePullPolicy: Never      # Pakai image lokal
        ports:
        - containerPort: 3000       # Port internal container (biasanya Nextjs/React/Node)
        
        # --- Bagian Environment Variable ---
        env:
        - name: NODE_ENV
          value: "production"
        # Jika frontend butuh URL Backend, biasanya ditambah di sini:
        # - name: NEXT_PUBLIC_API_URL
        #   value: "http://IP-SERVER-ANDA:30009" 

---
# --- SERVICE ---
apiVersion: v1
kind: Service
metadata:
  name: ai-note-fe-service
spec:
  type: NodePort
  selector:
    app: ai-note-fe
  ports:
    - port: 3000          # Port Cluster
      targetPort: 3000    # Port Container
      nodePort: 30008     # Port Akses Luar (Sesuai keinginan Anda: 3008)
```

```
k apply -f fe-deploy.yaml
```

```
k get pods
```