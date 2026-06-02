# Gerenciamento e Provedor de Infraestrutura de Aplicação na AWS

[![AWS](https://img.shields.io/badge/AWS-100%25-orange?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-IaC-purple?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Draw.io](https://img.shields.io/badge/Draw.io-Diagram-blue?style=for-the-badge&logo=diagrams.net&logoColor=white)](https://app.diagrams.net/)

Este repositório contém a modelagem arquitetural e a definição de infraestrutura como código (IaC) para um fluxo de gerenciamento de dados resiliente e seguro na AWS. O projeto representa um fluxo de aplicação web hospedado em instâncias EC2, integrado a bancos de dados relacionais e pipelines serverless de armazenamento de objetos.

---

## 🗺️ Visão Geral da Arquitetura

O diagrama abaixo ilustra o fluxo de dados e o zoneamento de rede estabelecido para esta arquitetura:

![Arquitetura AWS](./architecture.png)

> [!NOTE]
> **Nota para o Avaliador:** O diagrama acima é gerado a partir do arquivo [`Desafio_DIO_AWS.drawio`](./Desafio_DIO_AWS.drawio). Para exportá-lo, siga as instruções na seção [Exportando o Diagrama](#-como-exportar-o-diagrama).

---

## 🛠️ Detalhamento dos Componentes

A infraestrutura foi projetada seguindo as melhores práticas descritas no **AWS Well-Architected Framework**:

1. **Virtual Private Cloud (VPC):**
   - Criação de um ambiente de rede logicamente isolado com bloco CIDR `10.0.0.0/16`.
   - Divisão inteligente de sub-redes:
     - **Subnets Públicas (`10.0.1.0/24`):** Onde residem os servidores de aplicação web (EC2) que precisam receber tráfego direto da internet.
     - **Subnets Privadas (`10.0.2.0/24` e `10.0.3.0/24`):** Onde residem o banco de dados (RDS) e as funções de processamento (Lambda), protegidos contra acessos externos diretos.

2. **Amazon EC2 (Application Server):**
   - Servidor virtual responsável pela execução da API / Aplicação principal.
   - Configuração de perfil de instância IAM (**IAM Instance Profile**) para autenticação segura com outros serviços da AWS sem chaves em texto claro.

3. **Amazon EBS (Elastic Block Store):**
   - Volume de armazenamento persistente do tipo `gp3` de alta performance anexado à instância EC2, ideal para armazenamento de logs de aplicação ou arquivos temporários que requerem baixa latência.

4. **Amazon RDS (Relational Database Service):**
   - Banco de dados relacional (PostgreSQL) implantado em sub-redes privadas.
   - Acesso estritamente limitado através de Security Groups para aceitar requisições originadas apenas da subnet da aplicação (EC2).

5. **AWS Lambda & Amazon S3 (Pipeline Serverless):**
   - **Trigger/Invocação:** A aplicação rodando no EC2 invoca a função AWS Lambda para processamentos assíncronos ou tarefas sob demanda.
   - **Armazenamento:** O Lambda executa o processamento e armazena de forma persistente os resultados estruturados em um bucket privado do **Amazon S3** com versionamento ativado.

---

## 🛡️ Segurança & DevOpsSec

A segurança foi integrada como prioridade em toda a modelagem:

* **Princípio do Menor Privilégio:** As funções IAM associadas à EC2 e ao Lambda limitam estritamente quais recursos e ações podem ser executados (ex: o Lambda possui permissão de leitura/escrita restrita a apenas um bucket S3 específico).
* **Bloqueio de Acesso Público no S3:** O bucket S3 possui políticas rígidas de bloqueio de acesso público (`block_public_acls = true`, `block_public_policy = true`), garantindo que nenhum dado vaze para a internet.
* **Segurança de Rede (Security Groups):**
  - **EC2 SG:** Permite entrada apenas nas portas `80` (HTTP), `443` (HTTPS) e `22` (SSH - restrito em ambiente produtivo).
  - **RDS SG:** Permite entrada na porta `5432` (PostgreSQL) **apenas** quando originada do Security Group da instância EC2.

---

## ⚙️ Infraestrutura como Código (Terraform)

Para demonstrar a maturidade técnica do projeto, toda a infraestrutura desenhada no diagrama foi mapeada e codificada na pasta [`/terraform`](./terraform):

```bash
terraform/
├── main.tf          # Definição dos recursos AWS (VPC, EC2, RDS, Lambda, S3, IAM)
├── variables.tf     # Parametrização e variáveis do ambiente
├── outputs.tf       # Exposição dos endpoints e IPs gerados após o deploy
└── lambda/
    └── index.py     # Código de teste executado pela função Lambda
```

### Como Inicializar o Terraform (Opcional)

Caso possua o Terraform CLI instalado, você pode validar a consistência sintática do projeto executando:

```bash
# Navegar até a pasta do Terraform
cd terraform

# Inicializar os provedores
terraform init

# Validar a sintaxe dos arquivos
terraform validate

# Planejar a execução e visualizar os recursos que seriam criados
terraform plan
```

---

## 🔄 Como Exportar o Diagrama

Para manter a documentação visual atualizada no GitHub:

1. Abra o arquivo [`Desafio_DIO_AWS.drawio`](./Desafio_DIO_AWS.drawio) usando o site [draw.io](https://app.diagrams.net/) ou o aplicativo Desktop do Draw.io.
2. No menu superior, vá em **Arquivo (File) ➔ Exportar como (Export as) ➔ PNG...**
3. Configure o fator de zoom em `100%` e marque a opção **Fundo Transparente**.
4. Salve o arquivo com o nome `architecture.png` na pasta raiz deste repositório.
5. Faça o commit e push do novo arquivo `architecture.png` para atualizar o gráfico no topo deste README.
