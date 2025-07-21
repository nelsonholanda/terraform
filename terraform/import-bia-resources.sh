#!/bin/bash

# Script para importar recursos da VPC atualizada para Terraform
# VPC ID: vpc-06abb7bcc6c85353e

set -e

echo "🚀 Iniciando importação dos recursos com VPC atualizada..."

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para log
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Função para importar com tratamento de erro
import_resource() {
    local resource_type=$1
    local resource_name=$2
    local resource_id=$3
    
    log_info "Importando $resource_type.$resource_name..."
    
    if terraform import "$resource_type.$resource_name" "$resource_id" 2>/dev/null; then
        log_info "✅ $resource_type.$resource_name importado com sucesso"
    else
        log_warn "⚠️  $resource_type.$resource_name já existe ou falhou na importação"
    fi
}

# Verificar se estamos no diretório correto
if [ ! -f "main.tf" ]; then
    log_error "Execute este script no diretório terraform/"
    exit 1
fi

# Inicializar Terraform
log_info "Inicializando Terraform..."
terraform init

# 1. IMPORTAR VPC E NETWORKING
log_info "=== IMPORTANDO VPC E NETWORKING ==="

import_resource "module.vpc.aws_vpc" "main" "vpc-06abb7bcc6c85353e"
import_resource "module.vpc.aws_subnet" "public_1a" "subnet-02b1420dc51868c2f"
import_resource "module.vpc.aws_subnet" "public_1c" "subnet-06d58aca0163a65b1"
import_resource "module.vpc.aws_subnet" "public_1f" "subnet-00aa6253f6ec5301e"
import_resource "module.vpc.aws_subnet" "private_1a" "subnet-08e3a6b660b4a9881"
import_resource "module.vpc.aws_subnet" "private_1c" "subnet-0a8702aaa5094f068"
import_resource "module.vpc.aws_subnet" "private_1f" "subnet-0c934f69a74511ec2"

log_info "✅ Importação da VPC e subnets concluída!"
log_warn "Próximos passos:"
echo "1. Execute 'terraform plan' para verificar o estado"
echo "2. Ajuste as configurações nos módulos conforme necessário"
echo "3. Execute 'terraform apply' para sincronizar o estado"

echo ""
log_info "📋 RESUMO DOS RECURSOS IMPORTADOS:"
echo "   • VPC: vpc-06abb7bcc6c85353e"
echo "   • 3 Subnets Públicas (us-east-1a, us-east-1c, us-east-1f)"
echo "   • 3 Subnets Privadas (us-east-1a, us-east-1c, us-east-1f)"
echo ""
echo "   ℹ️  Configuração atualizada com os IDs corretos da AWS"