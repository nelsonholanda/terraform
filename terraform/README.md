# Terraform Infrastructure para Cluster ECS BIA

Este projeto contém a infraestrutura como código (IaC) para o cluster ECS `cluster-bia-ecs` e todos os recursos relacionados.

## 📋 Recursos Gerenciados

### 🌐 Networking
- **VPC**: `vpc-050a60d717044c305`
- **Subnets Públicas**:
  - `subnet-0980dfd09f18b0375` (us-east-1a)
  - `subnet-0231fd10b74a1184d` (us-east-1d) 
  - `subnet-0b616c224b03b21dd` (us-east-1f)

### 🐳 ECS Resources
- **Cluster**: `cluster-bia-ecs`
- **Service**: `service-bia`
- **Task Definition**: `task-asg-bia:4`
- **Capacity Provider**: Auto Scaling baseado

### 📦 Container Registry
- **ECR Repository**: `bia`
- **Image**: `194722426008.dkr.ecr.us-east-1.amazonaws.com/bia:latest`

### 🚀 Compute
- **Auto Scaling Group**: Instâncias t3.micro
- **Launch Template**: ECS-optimized AMI
- **Min/Max/Desired**: 1/4/1 instâncias

### 🔒 Security & IAM
- **Security Group**: `sg-09e9f40d8c89ed4ca`
- **IAM Roles**: 
  - `ecsTaskExecutionRole`
  - `ecsInstanceRole`
- **Instance Profile**: `ecsInstanceRole`

### 📊 Monitoring
- **CloudWatch Log Group**: `/ecs/task-asg-bia`

## 🏗️ Estrutura do Projeto

```
terraform/
├── main.tf                 # Configuração principal
├── variables.tf            # Variáveis
├── outputs.tf             # Outputs
├── import-resources.sh    # Script de importação
├── modules/
│   ├── vpc/              # Módulo VPC e Subnets
│   ├── ecs-cluster/      # Módulo ECS Cluster
│   ├── ecs-service/      # Módulo ECS Service
│   ├── ecr/              # Módulo ECR
│   ├── iam/              # Módulo IAM
│   ├── security-groups/  # Módulo Security Groups
│   └── cloudwatch/       # Módulo CloudWatch
└── environments/
    └── prod/             # Configuração de produção
```

## 🚀 Como Usar

### 1. Pré-requisitos
```bash
# Verificar se o Terraform está instalado
terraform --version

# Verificar credenciais AWS
aws sts get-caller-identity
```

### 2. Importar Recursos Existentes
```bash
cd terraform
./import-resources.sh
```

### 3. Verificar Configuração
```bash
# Planejar mudanças
terraform plan

# Aplicar mudanças (se necessário)
terraform apply
```

## 📝 Variáveis Principais

| Variável | Descrição | Valor Padrão |
|----------|-----------|--------------|
| `aws_region` | Região AWS | `us-east-1` |
| `cluster_name` | Nome do cluster ECS | `cluster-bia-ecs` |
| `service_name` | Nome do serviço ECS | `service-bia` |
| `container_cpu` | CPU do container | `1024` |
| `container_memory_reservation` | Memória reservada (MB) | `307` |
| `container_port` | Porta do container | `8080` |

## 🔧 Configuração do Container

### Variáveis de Ambiente
- `DB_PWD`: rdms95gn
- `DB_HOST`: bia.cx4q6caas2ti.us-east-1.rds.amazonaws.com
- `DB_PORT`: 5432
- `DB_USER`: postgres

### Configuração de Rede
- **Network Mode**: bridge
- **Port Mapping**: Container 8080 → Host dinâmico
- **Protocol**: HTTP

## 📊 Monitoramento

### CloudWatch Logs
- **Log Group**: `/ecs/task-asg-bia`
- **Retention**: 7 dias
- **Stream Prefix**: ecs

### Métricas ECS
- Container Insights: Desabilitado
- Auto Scaling: Habilitado (target 100%)

## 🔒 Segurança

### Security Group Rules
- **Inbound**:
  - SSH (22): 0.0.0.0/0
  - HTTP (80): 0.0.0.0/0
  - HTTPS (443): 0.0.0.0/0
  - Dynamic Ports (32768-65535): 0.0.0.0/0
- **Outbound**: All traffic

### IAM Permissions
- ECS Task Execution Role: Políticas AWS gerenciadas
- ECS Instance Role: Políticas AWS gerenciadas

## 🚨 Comandos Úteis

### Verificar Status do Cluster
```bash
aws ecs describe-clusters --clusters cluster-bia-ecs
```

### Listar Serviços
```bash
aws ecs list-services --cluster cluster-bia-ecs
```

### Ver Logs do Container
```bash
aws logs tail /ecs/task-asg-bia --follow
```

### Atualizar Imagem do Container
```bash
# Build e push nova imagem
docker build -t bia .
docker tag bia:latest 194722426008.dkr.ecr.us-east-1.amazonaws.com/bia:latest
docker push 194722426008.dkr.ecr.us-east-1.amazonaws.com/bia:latest

# Forçar nova deployment
aws ecs update-service --cluster cluster-bia-ecs --service service-bia --force-new-deployment
```

## ⚠️ Considerações Importantes

1. **Backup**: Todos os recursos têm `prevent_destroy = false` para evitar exclusão acidental
2. **Custos**: Monitore os custos das instâncias EC2 e transferência de dados
3. **Segurança**: Revise as regras do security group para produção
4. **Escalabilidade**: Ajuste min/max do Auto Scaling Group conforme necessário
5. **Monitoramento**: Configure alertas CloudWatch para métricas críticas

## 🔄 Atualizações

Para atualizar a infraestrutura:

1. Modifique os arquivos `.tf` necessários
2. Execute `terraform plan` para revisar mudanças
3. Execute `terraform apply` para aplicar mudanças
4. Monitore os logs e métricas após a aplicação

## 📞 Suporte

Para dúvidas ou problemas:
1. Verifique os logs do CloudWatch
2. Revise o estado do Terraform: `terraform show`
3. Consulte a documentação AWS ECS