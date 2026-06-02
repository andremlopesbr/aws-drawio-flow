# 📝 Observações Técnicas e Aprendizados

Durante a execução prática deste laboratório de infraestrutura AWS, foram coletadas as seguintes observações e boas práticas para gerenciamento de instâncias EC2 e armazenamento EBS:

---

## 1. Gerenciamento de Instâncias EC2
* **Ciclo de Vida:** 
  * A transição do estado **Stopping** para **Stopped** encerra o faturamento do recurso computacional (vCPU e RAM), porém o armazenamento associado (EBS) continua sendo cobrado.
  * O estado **Terminated** remove permanentemente a instância. Por padrão, volumes root EBS configurados com a flag `DeleteOnTermination = true` são deletados automaticamente neste processo.
* **Segurança de Acesso:** 
  * O acesso SSH via terminal foi configurado utilizando pares de chaves públicas/privadas RSA. Recomenda-se manter a permissão do arquivo de chave privada (`.pem`) restrita (`chmod 400` no Linux/macOS) para permitir a conexão segura.

---

## 2. Elastic Block Store (EBS) & Snapshots
* **Snapshots Incrementais:**
  * Os snapshots do EBS salvam apenas os blocos modificados desde o último snapshot. Isso reduz significativamente o custo de armazenamento de backups contínuos no S3 (gerenciado internamente pela AWS).
* **Consistência de Dados:**
  * Para realizar snapshots de volumes com segurança em produção, é altamente recomendável pausar temporariamente as escritas no disco (ou parar a instância) para evitar a corrupção do sistema de arquivos durante a cópia dos blocos.
* **Ciclo de Vida Automatizado (Data Lifecycle Manager - DLM):**
  * Em projetos corporativos, recomenda-se configurar regras no AWS DLM para automatizar a criação e expiração de snapshots periódicos de acordo com a política de retenção da empresa.

---

## 3. Integração Serverless e Armazenamento
* **Amazon S3:**
  * Configurado com versionamento para proteção contra exclusão acidental ou modificação de arquivos de processamento enviados pelo AWS Lambda.
* **Comunicação por IAM Roles:**
  * O privilégio de gravação no S3 concedido ao Lambda é executado de maneira segura através de perfis do IAM, dispensando credenciais permanentes embutidas no código.
