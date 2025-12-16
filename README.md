# 🚀 CRUD Serverless com Notificações SNS

[![Serverless](https://img.shields.io/badge/Serverless-Framework-red.svg)](https://www.serverless.com/)
[![LocalStack](https://img.shields.io/badge/LocalStack-Enabled-green.svg)](https://localstack.cloud/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-brightgreen.svg)](https://nodejs.org/)
[![AWS Lambda](https://img.shields.io/badge/AWS-Lambda-orange.svg)](https://aws.amazon.com/lambda/)

## 📋 Descrição

Aplicação CRUD (Create, Read, Update, Delete) completa utilizando arquitetura serverless com **Serverless Framework** e **LocalStack**, integrando notificações via **Amazon SNS** para eventos do sistema.

### ✨ Características Principais

- ✅ **API REST** com operações CRUD completas
- ✅ **Funções Lambda** para cada operação (Create, Read, Update, Delete)
- ✅ **Persistência de dados** utilizando DynamoDB
- ✅ **Notificações via SNS** em eventos de criação e atualização
- ✅ **Subscriber SNS** para processar notificações em tempo real
- ✅ **Ambiente local** simulado com LocalStack
- ✅ **Validação de dados** nas operações de criação e atualização

---

## 🛠️ Stack Tecnológica

| Tecnologia | Descrição |
|------------|-----------|
| **Serverless Framework** | Framework para deploy de aplicações serverless |
| **LocalStack** | Emulador local dos serviços AWS |
| **AWS Lambda** | Funções serverless para lógica de negócio |
| **API Gateway** | Exposição dos endpoints REST |
| **DynamoDB** | Banco de dados NoSQL para persistência |
| **Amazon SNS** | Serviço de notificações em tópico |
| **Node.js 18.x** | Runtime para as funções Lambda |
| **Docker** | Containerização do LocalStack |

---

## 📌 Funcionalidades Obrigatórias

### ✅ 1. CRUD Completo
Implementadas as 4 operações básicas via endpoints REST:
- `POST /items` - Criar novo item
- `GET /items` - Listar todos os itens
- `GET /items/{id}` - Buscar item por ID
- `PUT /items/{id}` - Atualizar item existente
- `DELETE /items/{id}` - Remover item

### ✅ 2. Notificação SNS
Publicação automática de mensagens no tópico SNS quando:
- Um novo recurso é **criado** (CREATE)
- Um recurso existente é **atualizado** (UPDATE)

### ✅ 3. Subscriber SNS
Função Lambda `snsSubscriber` inscrita no tópico SNS que:
- Recebe notificações automaticamente
- Processa e registra logs detalhados
- Pode ser estendida para enviar emails, webhooks, etc.

### ✅ 4. Validação de Dados
Validação de entrada nas operações:
- Campos obrigatórios: `title` e `description`
- Campos opcionais: `priority` e `completed`
- Retorno de erro 400 para dados inválidos

---

## 📡 Endpoints da API

| Método | Endpoint | Descrição | Notificação SNS |
|--------|----------|-----------|-----------------|
| `POST` | `/items` | Criar novo item | ✅ Sim |
| `GET` | `/items` | Listar todos os itens | ❌ Não |
| `GET` | `/items/{id}` | Buscar item por ID | ❌ Não |
| `PUT` | `/items/{id}` | Atualizar item existente | ✅ Sim |
| `DELETE` | `/items/{id}` | Remover item | ❌ Não |

### Exemplo de Payload (POST/PUT)
```json
{
  "title": "Minha Tarefa",
  "description": "Descrição da tarefa",
  "priority": "high",
  "completed": false
}
```

---

## 🚀 Como Executar

### 📦 Pré-requisitos

- **Node.js** 18.x ou superior
- **Docker** e **Docker Compose**
- **PowerShell** (Windows) ou **Bash** (Linux/Mac)

### 1️⃣ Instalar Dependências

```bash
cd serverless
npm install
```

### 2️⃣ Iniciar LocalStack

```bash
# No diretório raiz do projeto
docker-compose up -d
```

Aguarde alguns segundos para o LocalStack inicializar completamente.

### 3️⃣ Verificar LocalStack

```bash
# Verificar status
docker ps

# Verificar saúde
curl http://localhost:4566/_localstack/health
```

### 4️⃣ Deploy das Funções

**Windows (PowerShell):**
```powershell
.\deploy-local.ps1
```

**Linux/Mac (Bash):**
```bash
chmod +x deploy-local.sh
./deploy-local.sh
```

### 5️⃣ Testar a API

**Windows (PowerShell):**
```powershell
.\test-api.ps1
```

**Linux/Mac (Bash):**
```bash
chmod +x test-api.sh
./test-api.sh
```

---

## 🧪 Testes Manuais com cURL

### Criar Item (POST)
```bash
curl -X POST http://localhost:4566/restapis/<API_ID>/local/_user_request_/items \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Nova Tarefa",
    "description": "Descrição da tarefa",
    "priority": "high"
  }'
```

### Listar Itens (GET)
```bash
curl http://localhost:4566/restapis/<API_ID>/local/_user_request_/items
```

### Buscar Item por ID (GET)
```bash
curl http://localhost:4566/restapis/<API_ID>/local/_user_request_/items/{id}
```

### Atualizar Item (PUT)
```bash
curl -X PUT http://localhost:4566/restapis/<API_ID>/local/_user_request_/items/{id} \
  -H "Content-Type: application/json" \
  -d '{
    "title": "Tarefa Atualizada",
    "completed": true
  }'
```

### Deletar Item (DELETE)
```bash
curl -X DELETE http://localhost:4566/restapis/<API_ID>/local/_user_request_/items/{id}
```

> **Nota:** Substitua `<API_ID>` pelo ID da API retornado no deploy. Geralmente aparece no console após o deploy.

---

## 📊 Visualizar Logs

### Logs do LocalStack
```bash
docker logs -f localstack
```

### Logs de uma Função Específica
```bash
cd serverless
serverless logs -f createItem --stage local --tail
```

### Verificar Notificações SNS
Os logs das notificações SNS são exibidos automaticamente pela função `snsSubscriber`. Procure por mensagens como:
```
📬 SNS Subscriber - Event
📨 NOTIFICAÇÃO SNS RECEBIDA
```

---

## 📂 Estrutura do Projeto

```
crud_serverless_sns/
├── README.md                       # Documentação completa
├── docker-compose.yml              # Configuração LocalStack
├── deploy-local.ps1                # Script deploy (Windows)
├── deploy-local.sh                 # Script deploy (Linux/Mac)
├── test-api.ps1                    # Script teste (Windows)
├── test-api.sh                     # Script teste (Linux/Mac)
└── serverless/
    ├── package.json                # Dependências Node.js
    ├── serverless.yml              # Configuração Serverless Framework
    └── functions/
        ├── createItem.js           # Lambda: Criar item + SNS
        ├── listItems.js            # Lambda: Listar itens
        ├── getItem.js              # Lambda: Buscar item por ID
        ├── updateItem.js           # Lambda: Atualizar item + SNS
        ├── deleteItem.js           # Lambda: Deletar item
        └── snsSubscriber.js        # Lambda: Processar notificações SNS
```

---

## 🔧 Configuração do LocalStack

O `docker-compose.yml` configura os seguintes serviços AWS localmente:

- **Lambda** - Execução das funções
- **DynamoDB** - Banco de dados NoSQL
- **SNS** - Serviço de notificações
- **API Gateway** - Exposição dos endpoints REST
- **CloudFormation** - Gerenciamento de recursos
- **IAM** - Gerenciamento de permissões
- **CloudWatch Logs** - Logs das execuções

Porta principal: **4566**

---

## 🎯 Modelo de Dados (DynamoDB)

### Tabela: `task-manager-serverless-items-local`

```json
{
  "id": "uuid-v4",
  "title": "String (obrigatório)",
  "description": "String (obrigatório)",
  "priority": "String (optional: low|medium|high)",
  "completed": "Boolean (optional, default: false)",
  "createdAt": "ISO8601 String",
  "updatedAt": "ISO8601 String"
}
```

---

## 📬 Estrutura das Mensagens SNS

### Evento CREATE
```json
{
  "action": "CREATE",
  "item": {
    "id": "abc-123",
    "title": "Nova Tarefa",
    "description": "Descrição",
    "priority": "high",
    "completed": false,
    "createdAt": "2025-12-15T10:30:00Z",
    "updatedAt": "2025-12-15T10:30:00Z"
  },
  "timestamp": "2025-12-15T10:30:00Z"
}
```

### Evento UPDATE
```json
{
  "action": "UPDATE",
  "item": {
    "id": "abc-123",
    "title": "Tarefa Atualizada",
    "completed": true,
    ...
  },
  "previousItem": {
    "id": "abc-123",
    "title": "Tarefa Antiga",
    "completed": false,
    ...
  },
  "timestamp": "2025-12-15T10:35:00Z"
}
```

---

## 🐛 Troubleshooting

### LocalStack não inicia
```bash
# Verificar se a porta 4566 está disponível
netstat -ano | findstr 4566

# Limpar e reiniciar
docker-compose down -v
docker-compose up -d
```

### Deploy falha
```bash
# Verificar se LocalStack está saudável
curl http://localhost:4566/_localstack/health

# Reinstalar dependências
cd serverless
rm -rf node_modules package-lock.json
npm install
```

### Notificações SNS não aparecem
```bash
# Verificar logs do subscriber
docker logs localstack | grep "SNS Subscriber"

# Verificar configuração do tópico
aws --endpoint-url=http://localhost:4566 sns list-topics
```

---

## 📈 Próximos Passos

- [ ] Adicionar testes unitários com Jest
- [ ] Implementar autenticação com Cognito
- [ ] Adicionar validação com JSON Schema
- [ ] Criar frontend React/Vue
- [ ] Deploy em AWS real (não LocalStack)
- [ ] Adicionar CI/CD com GitHub Actions
- [ ] Implementar DynamoDB Streams
- [ ] Adicionar métricas com CloudWatch

---

## 📝 Evidências de Funcionamento

### ✅ Logs de Execução

Após executar `test-api.ps1` ou `test-api.sh`, você verá:

1. **Criação de Item:**
   - Status 201
   - Item com ID único gerado
   - Notificação SNS enviada

2. **Listagem de Itens:**
   - Status 200
   - Array com todos os itens

3. **Busca por ID:**
   - Status 200
   - Item específico retornado

4. **Atualização:**
   - Status 200
   - Item modificado
   - Notificação SNS enviada

5. **Deleção:**
   - Status 200
   - Item removido

6. **Logs do Subscriber:**
   - Mensagens SNS processadas
   - Detalhes completos das mudanças

---

## 👨‍💻 Autor

**Cristiano** - Projeto desenvolvido como exemplo de arquitetura serverless com notificações SNS.

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE para mais detalhes.

---

## 🙏 Agradecimentos

- [Serverless Framework](https://www.serverless.com/)
- [LocalStack](https://localstack.cloud/)
- [AWS Documentation](https://docs.aws.amazon.com/)

---

**⭐ Se este projeto foi útil, considere dar uma estrela no repositório!**
