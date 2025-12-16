#!/bin/bash
# Script Bash para deploy no LocalStack

echo ""
echo -e "\033[0;36mIniciando deploy do Serverless no LocalStack...\033[0m"
echo ""

# Verificar se LocalStack está rodando
echo -e "\033[0;33m1. Verificando LocalStack...\033[0m"
if curl -s -o /dev/null -w "%{http_code}" http://localhost:4566/_localstack/health | grep -q "200"; then
    echo -e "\033[0;32m[OK] LocalStack está rodando\033[0m"
else
    echo -e "\033[0;31m[ERRO] LocalStack não está rodando!\033[0m"
    echo -e "\033[0;33mExecute: docker-compose up -d\033[0m"
    exit 1
fi
echo "✅ LocalStack está rodando"

# Ir para pasta serverless
cd serverless

# Instalar dependências
echo ""
echo -e "\033[0;33m2. Instalando dependências...\033[0m"
npm install

# Deploy
echo ""
echo -e "\033[0;33m3. Fazendo deploy das funções Lambda...\033[0m"
npm run deploy

echo ""
echo -e "\033[0;32m[OK] Deploy concluído!\033[0m"
echo ""
echo -e "\033[0;36mPróximos passos:\033[0m"
echo "  1. Teste os endpoints: ./test-api.sh"
echo "  2. Veja os logs: cd serverless; serverless logs -f createItem --stage local"
echo ""
