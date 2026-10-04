<!-- docqui: 4.1.0 | prompt: PROMPT_CONTAGEM | atualizado: 2026-10-04 -->
# SIZING.md
> Convenções de medição de tamanho funcional do sistema.
> Fonte única de critérios para contagem APF e COSMIC.
> Atualizar sempre que uma nova convenção for adotada.
>
> ℹ️ **Template do kit** — a metodologia APF/COSMIC é reutilizável. A seção
> **"Regras de medição de serviços (CAIXA)"** e as menções a stack (Angular/Java)
> são específicas de organização/projeto — revise ou substitua conforme o seu caso.

---

## Normas adotadas

| Método | Norma | Versão |
|---|---|---|
| APF | IFPUG CPM | 4.3.1 |
| APF — regras do contrato | Guia de Métricas da STI | 1.3 (dez/2025) |
| COSMIC | COSMIC FSM | 5.0 |

**Precedência**: as regras do **Guia de Métricas da STI** se sobrepõem às definições do CPM *(decisão do usuário, 2026-10-04)*. Onde o Guia dispõe, vale o Guia; onde ele cala, vale o CPM. O texto integral está na skill `apf-cpm` (`references/guia-metricas-sti/`, com o índice do que ele decide diferente do manual em `00-indice.md`), e a memória de cálculo cita a seção quando a regra vem dele.

> ⚠️ Registre aqui a versão exata adotada pela organização antes de iniciar qualquer contagem.

---

## APF — Análise de Pontos de Função

> **Princípio — a contagem reflete o que está documentado.** Cada DER, ALR, RLR,
> tipo (EE/SE/CE/ALI/AIE) e complexidade deve ser **rastreável** ao que o N3 e o
> `DATA-MODEL.md` registram (tabela `## Campos`, dependências, entidades/ALIs). A
> contagem **não antecipa nem inventa** o que não está especificado: se um campo,
> leitura ou entidade for necessário ao número mas não estiver documentado, **registre
> a lacuna com ⚠️ e ajuste a fonte antes de fechar a contagem** — em vez de estimar.
> Sempre que o que está documentado mudar, **reconte**. Regra de ouro: **a fonte
> manda; a contagem a espelha.**

### Mapeamento da estrutura de documentação → elementos APF

| Elemento APF | Definição | Onde identificar nesta estrutura |
|---|---|---|
| ALI (Arquivo Lógico Interno) | Grupo de dados mantido pelo sistema | `global/DATA-MODEL.md` — uma entidade principal = um ALI candidato; registro em `global/ALI-AIE-MAP.md` |
| AIE (Arquivo de Interface Externa) | Grupo de dados de sistema externo usado mas não mantido | `global/DATA-MODEL.md` (tabela de AIEs) e `global/ALI-AIE-MAP.md`; as candidatas surgem da seção "Integrações" do N1, do `global/API-PATTERNS.md` e dos campos `externo: [Sistema]` do N3 |
| EE (Entrada Externa) | Transação que processa dados de fora para dentro — intenção primária: **manter** ALI ou **alterar o comportamento** do sistema | a feature (N3) inteira, front + BFF (ver *Arquitetura BFF*); no perfil `completo`, o `## API` confere — verbos POST / PUT / PATCH / DELETE |
| SE (Saída Externa) | Transação que envia dados com lógica de processamento — cálculo, dado derivado, manutenção de ALI ou alteração de comportamento | a feature (N3) inteira; no perfil `completo`, o `## API` confere — GET com cálculo, relatório ou transformação |
| CE (Consulta Externa) | Transação que recupera dados de ALI/AIE sem lógica adicional | a feature (N3) inteira; no perfil `completo`, o `## API` confere — GET simples de listagem ou detalhe |

> **A transação se classifica pela intenção primária**, com as formas de lógica da skill `apf-cpm` — não pelo verbo HTTP nem pela exposição do endpoint. Uma feature atendida só pelo BFF interno conta se for processo elementar (ver *Arquitetura BFF*), e um GET que calcula totais é SE. O `## API` só existe no perfil `completo` e serve de conferência; no perfil `requisitos`, a classificação sai das seções negociais do N3.

> **Todo número contado vem com memória de cálculo.** Cada linha — de transação ou de função de dados — registra a **quantidade e a descrição** dos seus ALR e DER: cada arquivo lógico nomeado com o motivo da leitura, cada campo nomeado e agrupado, e o que ficou de fora com o porquê. Número sem memória não é auditável (não dá para dizer se o ALR esqueceu um arquivo ou se o DER contou o mesmo campo duas vezes) nem comparável entre recontagens (não dá para saber o que mudou). A memória mora junto do número: na `## Métricas de tamanho` do N3, para transações, e no `CONTAGEM-PF.md`, para funções de dados. Na transação, a enumeração de ALR e DER é um bloco ```json por processo elementar (`{"pe", "alr", "der"}`), só com nomes; o motivo de cada leitura fica em prosa, fora dele.

### Critério de complexidade — Funções de Dados (ALI / AIE)

| RLR \ DER | 1–19 | 20–50 | 51+ |
|---|---|---|---|
| 1 | Baixa | Baixa | Média |
| 2–5 | Baixa | Média | Alta |
| 6+ | Média | Alta | Alta |

> **RLR** (Registro Lógico Referenciado) = IFPUG RET · **DER** (Dado Elementar Referenciado) = IFPUG DET. Ver glossário.

**Como contar DER**: cada campo das entidades que formam o ALI/AIE, no fragmento `global/data-models/[dominio].md` = 1 DER — a função de dados se conta pelo data-model, não pela tela de uma feature. Campos globais técnicos (createdAt, updatedAt, deletedAt) e organizationId = **não contam**. **O identificador (`id`) conta como 1 DER, mas uma única vez por ALI** — não por tabela: quando o ALI agrupa mais de uma entidade (1:N com a filha dependente), o `id` da entidade-mãe **não** conta de novo como chave estrangeira na filha, porque é o mesmo dado reconhecido pelo usuário. Chave estrangeira que aponta para **outro** ALI continua valendo 1 DER (relacionamento requerido pelo usuário — CPM 5.4.4c).
**Como contar RLR**: subgrupos lógicos dentro da entidade. Na ausência de subgrupos explícitos, considerar RLR = 1.

### Critério de complexidade — Funções de Transação

O CPM tem **duas** tabelas de complexidade para transações, com faixas diferentes: uma para Entrada Externa e outra para Saída Externa e Consulta Externa. Uma tabela única para os três tipos **não existe** no padrão — ela subdimensiona a EE com 3 ALR e superdimensiona SE e CE, que toleram mais DER antes de subir de faixa.

**Entrada Externa (EE)** — CPM 4.3.1, Tabela 6:

| ALR \ DER | 1–4 | 5–15 | 16+ |
|---|---|---|---|
| 0–1 | Baixa | Baixa | Média |
| 2 | Baixa | Média | Alta |
| 3+ | Média | Alta | Alta |

**Saída Externa (SE) e Consulta Externa (CE)** — CPM 4.3.1, Tabela 7:

| ALR \ DER | 1–5 | 6–19 | 20+ |
|---|---|---|---|
| 0–1 | Baixa | Baixa | Média |
| 2–3 | Baixa | Média | Alta |
| 4+ | Média | Alta | Alta |

> **ALR** (Arquivo Lógico Referenciado) = IFPUG FTR · **DER** = IFPUG DET. Ver glossário.

> ⚠️ **Correção de 2026-08-29.** Até esta data havia aqui **uma tabela só** para os três tipos, que combinava as faixas de DER da EE (1–4 / 5–15 / 16+) com as faixas de ALR da SE/CE (0–1 / 2–3 / 4+) — errada para os dois lados. **Contagens fechadas antes desta data precisam ser reconferidas**: pela tabela única, EE com 3 ALR caía na linha do meio e ficava uma faixa **abaixo** do devido, e SE/CE com 6 a 19 DER subiam uma faixa **acima**.

**Como contar ALR**: número de ALIs ou AIEs lidos ou mantidos pela transação, apurado em **quatro fontes**: (a) a coluna **Entidade** da tabela `## Campos` do N3 — as entidades distintas ali são arquivos lógicos referenciados; (b) as **entidades-fonte** dos campos calculados em `## Derivações`; (c) a seção **`## Dados lidos e gravados`**; (d) uma **varredura de `## Regras de negócio` e `## Campos automáticos`** atrás de entidade citada que não apareça nas três primeiras. As fontes (a)–(c) traduzem-se assim: nome de entidade = ALI · `externo: [Sistema]` = AIE · **`dado de código` não conta** (lista de valores fixos, sem cadastro por trás — CPM 5.4.2d) · `derivado ↓` = as entidades citadas em `## Derivações`. A quarta fonte existe porque as outras são **ancoradas em campo**: a tabela de campos descreve *a tela*, o ALR descreve *a transação* — entidade que a feature toca sem exibir campo algum (o registro de execução que recebe o status, o cronograma que define a janela válida) só aparece nas regras. Achou uma lá? Declare-a em `## Dados lidos e gravados` antes de contar — o número tem de estar sustentado pela fonte. Confronte com o data-model; nas instâncias de perfil `completo`, a seção `## Dependências` (libs/serviços) e o `## API` servem só de conferência — **nenhuma das duas declara arquivo lógico**, e no perfil `requisitos` elas nem existem no artefato.
**Como contar DER**: campos que cruzam a fronteira — os que entram (informados na tela, no comando ou no body/query da requisição) e os que saem (exibidos, ou devolvidos na resposta de sucesso), rastreáveis a `## Campos`, `## Campos automáticos` e `## Colunas do resultado` do N3. Conte cada campo distinto **uma vez** (entrada ∪ saída) e some **+1 DER para a capacidade de mensagens** (erro/confirmação) e **+1 DER para a ação/comando** que dispara a transação (padrão IFPUG). Campos de controle (HTTP status, organizationId, cursor de paginação) = **não contam**. O **+1 da mensagem** só existe quando o processo exibe mensagem (erro, confirmação, aviso): a **lista consultada** — combo, autocomplete, carrossel, botões — não exibe, e conta só o +1 da ação *(decisão do PO, 2026-10-02)*. Cada DER é uma informação que o usuário vê ou informa, nomeada com o rótulo da tela: a opção de lista que mostra número do contrato, tipo de material e fornecedor juntos são **três** DER, e o que a tela não mostra não é DER daquele processo. **O mesmo atributo no filtro e na coluna do resultado é um DER só** — é a união, não a soma. E **atributo diferente com o mesmo rótulo ganha nome pelo contexto**: o `Email` do fornecedor e o do gestor são `Email` e `Email do gestor`; o `Código` do item e o do rateio, `Código` e `Código do rateio` — no bloco, nome repetido se lê como o mesmo campo contado duas vezes, e o validador reprova *(retro de 2026-10-04: a contagem oficial do portal-compras trazia os dois casos)*. Na memória de cálculo, o bloco ```json do processo elementar leva só esses nomes — é ele que vai à coluna Descrição da planilha de entrega (gate F11, `valida-enumeracao-contagem.mjs`).

### Tabela de pontos por complexidade

| Tipo | Baixa | Média | Alta |
|---|---|---|---|
| ALI | 7 | 10 | 15 |
| AIE | 5 | 7 | 10 |
| EE | 3 | 4 | 6 |
| SE | 4 | 5 | 7 |
| CE | 3 | 4 | 6 |

---

## APF — Regras de medição de serviços (CAIXA)

> Orientações específicas para a medição de serviços em APF, adaptadas à estrutura
> de documentação deste template (N1, N3, fronteira BFF, `DATA-MODEL.md`).
> Origem: *Guia de Orientação de Métricas* — Capítulo 2, "Medição de Serviços em APF".
> Estas regras **prevalecem sobre o critério genérico** das seções anteriores quando houver conflito.
>
> ⚠️ Elas vêm do guia de outro contratante. Nas contagens entregues à STI, valem **só onde o Guia de Métricas da STI cala** (ver *Normas adotadas*): em conflito, vale o Guia da STI. É o caso do item 9 — o Guia parte do *multiple instance*, com as exceções da seção 5.1 dele.

### 1. Fronteira da aplicação e escopo

- A fronteira de uma aplicação é definida, por padrão, **a nível da sigla do sistema** — o equivalente, neste template, ao domínio/sistema documentado no N0/N1.
- Uma sigla pode conter **mais de um módulo**. Quando um módulo for tratado como fronteira separada, isso **deve estar explícito** na documentação (N1 do módulo) e no formulário de contagem.
- A definição de fronteira e de escopo é **prerrogativa da CAIXA** e pode ser ajustada a qualquer momento conforme a visão de negócio; o escopo da medição sempre considera os objetivos da organização, não a conveniência técnica.

> **Aplicação neste template**: alinhe a fronteira de contagem com a granularidade declarada no N0/N1. Se um domínio em `modules/` representa um módulo com fronteira própria, registre essa decisão no N1 antes de contar.

### 2. Migração de base de dados

Migração pressupõe um sistema/funcionalidade novo substituindo um existente, exigindo extração dos dados antigos e carga no novo.

| Elemento | Conta? | Como tratar |
|---|---|---|
| Carga/conversão e gravação dos dados no novo sistema | **Sim** | EE — normalmente **uma EE por grupo de dados migrado**, mas não é regra: contar conforme a visão do usuário. Cada EE engloba extração/leitura do antigo, conversão e carga no novo |
| Relatórios sobre a conversão solicitados pelo gestor | **Sim** | CE ou SE conforme houver lógica de processamento |
| Arquivos/tabelas do sistema antigo (origem) | **Não** | Não contar como AIE |
| Extrações de leitura do sistema antigo | **Não** | Não contar como CE nem SE |

- A CAIXA pode classificar o esforço como **Projeto de Migração de Base de Dados** (escopo específico), aplicando integralmente os conceitos IFPUG. Sem essa classificação, vale a regra geral acima.
- **Não recomendado** adotar Projeto de Migração de Base de Dados em soluções de Portal de Conteúdo.
- No artefato de contagem do projeto de migração, as **funções de dados são obrigatórias e oriundas do projeto de desenvolvimento**; quando a função já tiver sido contada no desenvolvimento, registrá-la com status **"não se aplica"**. Pré-requisito: modelo de dados do sistema (ou artefato similar).
- Situações não previstas → encaminhar ao **GT de Métricas**.

### 3. Fator de ajuste (VAF) — não adotado

- A aplicação das CGSs, o cálculo do VAF e o tamanho funcional **ajustado** são opcionais no CPM do IFPUG.
- **A CAIXA não adota Pontos de Função Ajustados.** Toda contagem registrada neste template é em **PF não ajustado** (FSM puro). Não preencher campos de VAF.

### 4. Contagem de AIE pela visão do usuário

- Contar os **grupos de dados distintos segundo a visão do usuário da aplicação que está sendo contada** — a fronteira depende da visão de negócio externa, **independente de considerações técnicas ou de implementação**.
- Quando um sistema externo organiza internamente um dado em vários grupos lógicos, conte **apenas o AIE que o negócio do sistema contado reconhece**, não os grupos técnicos subjacentes.

> **Exemplo (Guia)**: o SIXXX recupera dados de "Unidade CAIXA" que, no sistema de origem (SIICO), vêm de três ALIs ("Unidade", "Imóvel", "Tipo de Meio de Comunicação"). Como o gestor do SIXXX só reconhece o grupo lógico **Unidade**, conta-se **somente o AIE "Unidade"**.
>
> **Aplicação neste template**: ao registrar AIEs em `global/DATA-MODEL.md`, descreva-os pela ótica de negócio do sistema consumidor, não pela modelagem física do sistema externo.

### 5. Alterações técnicas em ALI e nas funções que o mantêm (CPM 4.3.1)

- Manutenções evolutivas e alterações de escopo que mexem em **características de campos** (tabelas/telas) **não são medidas por APF quando a motivação é puramente técnica**.
- Alteração de atributo só é medida quando atende a uma **necessidade de negócio**, comprovada por evidência da solicitação do gestor e aprovação de suporte/qualidade (CPM 4.3.1, Parte 2).
- O simples fato de um DER alterado **cruzar a fronteira** nas transações que o mantêm/referenciam **não basta** para pontuá-las como alteradas. Pontuar **apenas as transações cuja lógica de processamento mudou** (ex.: nova regra de validação do DER).

> **Exemplo (Guia)**: campo de telefone passa a aceitar 8 dígitos e, no DF, exige o dígito "3" inicial. As EE de inclusão e alteração de cliente mudam de lógica → pontuadas como "alteradas". Exclusão e consulta de cliente não mudam → **não pontuadas**.
>
> **Aplicação neste template**: ao alterar um campo no N3, registre na seção de métricas **se a mudança altera a lógica de processamento**; mudanças apenas técnicas (tamanho, tipo físico, otimização de banco) não geram pontos.

### 6. Integração de sistemas e middleware

- Para integração entre sistemas, aplicar os **cenários de compartilhamento de dados do CPM 4.3.1**.
- Quando a integração de dados é **provida por outra aplicação (middleware)**, adotar o white paper do IFPUG *Pontos de Função & Contagem de Software Aplicativo Middleware* (ex.: SICLI – IPPO, Interface Padrão Parametrizada Online).

### 7. Integração com sistema de segurança (LOGON)

- As unidades possuem **estruturas de segurança distintas**; avaliar o cenário concreto na contagem.
- Os **ALR** (Arquivos Lógicos Referenciados) devem ser avaliados para determinar a complexidade da função de transação **LOGON**, e precisam estar registrados nos insumos de contagem apresentados.
- Em funções de transação que referenciam o sistema de segurança (ex.: SISGR), contar com base na **necessidade de negócio**, não na restrição tecnológica.

### 8. Consultas dinâmicas

- Uma consulta dinâmica é **uma única função transacional CE ou SE**, independentemente da quantidade de resultados que produz.
- A complexidade é determinada pelo **cenário mais abrangente**, considerando todos os DER e ALR possíveis.

### 9. Funcionalidades iguais em formatos de saída diferentes

> ⚠️ **Convenção local, divergente do CPM.** Vale nos três sistemas do conjunto — Portal de Compras, Transparência Web e Prêmio IEL — e substitui a regra herdada do guia CAIXA, que mandava contar uma vez só.

- **Toda exportação construída é um processo elementar próprio.** Uma consulta em tela que exporta para Excel, PDF ou qualquer outro formato conta **uma função de transação por formato**, ainda que entregue exatamente o mesmo conjunto de dados da tela. Três formatos = três PE.
- **Nome do PE**: o nome da funcionalidade que origina a exportação — em geral um *Consultar …* — seguido do **formato entre parênteses**. Ex.: `Consultar Clientes (PDF)`, `Consultar Clientes (Excel)`. O que distingue as linhas é o formato; o nome da funcionalidade não muda de uma para a outra.
- **Só conta o que existe.** O formato precisa estar implementado ou especificado para construção — formato hipotético ("poderia sair em CSV") não vira PE.
- **O que muda em relação ao padrão**: o CPM 4.3.1 **não adota** *Multiple Media* (Capítulo 1, item 5.6) e trata processos elementares com o mesmo conjunto de DER, ALR e lógica de processamento como um único PE (Parte 4, cap. 2). Pelo manual, a exportação seria contada uma vez. Estes contratos contam por formato porque cada um exige geração, leiaute e verificação próprios, e é assim que o esforço é contratado.
- **Consequência a declarar**: uma contagem feita sob esta convenção **não é uma contagem IFPUG pura**. Ao entregá-la a auditoria externa ou a medição contratual, informe a divergência — do contrário os números não conciliam com uma recontagem pelo manual.
- **Como contar**: os formatos compartilham ALR e a maior parte dos DER; some **os mesmos DER em cada PE**, sem o campo que escolhe o formato — na contagem por formato, o formato deixa de ser dado de entrada e passa a ser a própria transação acionada.
- **Isto não decide a granularidade da feature.** PE e feature são unidades distintas: uma feature absorve quantos PEs forem necessários. Unificar duas exportações numa feature só **não retira PF** — os dois PEs continuam contando, agora sob uma feature só.
- **Linha vinda de baseline externo mantém o nome de origem.** Onde a contagem veio de planilha da equipe de métricas (`*_BASELINE_PF_CD.xlsx`), o nome do PE fica **como está na planilha**, para a auditoria cruzada; a convenção de nome acima vale para as contagens feitas daqui em diante.

> **Evidência no baseline do Prêmio IEL**: `Relatório de Inscrições Paradas` e `Exportar Relatório de Inscrições Paradas para Excel` têm **ALR 5 e DER 37 idênticos** — listas de DER conferidas elemento a elemento — e ainda assim contam 7 PF cada. Em qualquer instância que seguisse o CPM à risca, esse par seria **um PE só**.

> ⚠️ **A conferir contra o Guia de Métricas da STI, que prevalece** (ver *Normas adotadas*). O Guia parte do *multiple instance*, mas abre exceções (seção 5.1): consulta em `.pdf`, `.doc` e `.xls` e consulta idêntica em tela e papel são **uma** função; relatório em mais de um formato conta por formato só quando a equipe desenvolve cada um — se a ferramenta gera os formatos, conta uma vez. A convenção local acima conta por formato em todos os casos. Mantida como está na regeneração 4.1.0 (2026-10-04), porque mudá-la altera PF já contados; a decisão é da equipe de métricas.

### 10. Desenvolvimento em múltiplas camadas (mainframe, web)

- Quando a **mesma transação** é disponibilizada em duas plataformas (ex.: mainframe e web), há **um único processo elementar** sob a APF — ambas implementam a mesma funcionalidade. **Não adotar *Multiple Media*.**
- Sob o **SNAP**, esse item **pode ser medido e remunerado** (havendo previsão contratual) pela subcategoria *Múltiplos Métodos de Saída* (Capítulo 8 do Guia).

### 11. Medição de componentes

- O desenvolvimento/manutenção de **componentes** é avaliado sob a **perspectiva funcional** (CPM 4.3.1).
- Considera-se **Componente de Software Reutilizável** o executável que oferece um serviço pré-definido e se comunica por interfaces padronizadas, com **todas** as características:

  - realiza uma funcionalidade específica;
  - tem capacidade de execução paralela (multiuso);
  - é intercambiável (não específico ao contexto);
  - é combinável com outros componentes;
  - é encapsulado (não investigável por suas interfaces);
  - é unidade de instalação e versionamento independente, comunicando-se somente via interfaces bem definidas;
  - adere a um modelo de componentes (.COM, CORBA, Java, etc.).

### 12. Funcionalidades batch

- Processos batch disparados pelo **relógio do sistema (clock)**, em que **nenhuma informação cruza a fronteira**, **não são processos elementares** (apenas complementam outro PE) — regra geral do IFPUG-CPC.
- **Exceção CAIXA**: reconhece-se a rotina batch como **função transacional** quando ela automatiza algo que poderia ser online e **todas** as condições abaixo se verificam:

  1. é a **menor unidade de atividade significativa** para o usuário e não é parte de outro processo elementar;
  2. a intenção primária é classificada **exclusivamente como EE**;
  3. ao final da execução a aplicação fica em **estado consistente**.

  Nesses casos conta-se como processo elementar — a forma de implementação (batch) é fator meramente tecnológico.

### 13. Terceira contagem (contagem final)

- Se **não houver alteração funcional**, a terceira contagem **não é necessária**.
- A equipe deve verificar se a contagem detalhada anterior não deixou de incluir funções (ex.: de conversão); nesse caso a **contagem final (terceira) é necessária**.
- Quando se adota a segunda contagem como final, **formalizar** a inexistência de alterações funcionais.

---

## COSMIC — Common Software Measurement International Consortium

### Mapeamento da estrutura de documentação → movimentos COSMIC

| Movimento | Definição | Onde identificar nesta estrutura |
|---|---|---|
| Entry (E) | Dado movendo-se de fora do processo para dentro | Campo no body/query do `## API` do N3 |
| Exit (X) | Dado movendo-se de dentro do processo para fora | Campo na resposta do `## API` do N3 |
| Read (R) | Leitura de dado persistido | Cada ALI/AIE consultado pela transação |
| Write (W) | Escrita de dado persistido | Cada ALI criado, alterado ou removido pela transação |

**1 CFP = 1 movimento (E, X, R ou W)**

### Convenções de contagem COSMIC nesta estrutura

- **Granularidade**: contar por endpoint documentado no `## API` do N3.
- **Entry**: cada campo distinto no body ou query params = 1 E. Campos de controle (authorization header, organizationId via JWT, cursor) = **não contam**.
- **Exit**: cada campo distinto na resposta de sucesso = 1 X. Envelope padrão (`data`, `meta`, `error`) = **não conta**, apenas os campos de negócio internos.
- **Read**: cada entidade/ALI lida para processar ou responder = 1 R. Leituras de validação (verificar duplicata, checar permissão) = **contam**.
- **Write**: cada entidade/ALI criada, atualizada ou removida = 1 W. Soft delete = 1 W.
- **Eventos publicados** (`## Eventos` do N3): cada evento publicado implica 1 X adicional.
- **Eventos consumidos** (`## Eventos` do N3): cada evento consumido implica 1 E adicional por campo relevante no payload.

---

## Convenções de registro no N3

Toda feature especificada no N3 deve ter a seção `## Métricas de tamanho` preenchida **após** a aprovação do N3 negocial e **antes** do início do desenvolvimento.

A contagem é responsabilidade do Dev, revisada pelo Tech Lead, e pode ser auditada pelo PO com base nos campos e endpoints documentados no mesmo N3.

### Arquitetura BFF (Java + Angular) — a unidade de contagem é a feature, não o endpoint

A fronteira da aplicação (CPM) é a interface conceitual entre o sistema e seus **usuários** — **não** a divisão técnica entre o Angular e o Java. Nesta arquitetura, o frontend Angular e o backend BFF são **camadas internas de uma mesma feature**: o BFF é apenas o backend.

Por isso, **a unidade de análise é a feature (N3) inteira**, não o endpoint isolado. Uma feature começa na interação do usuário no front, percorre o BFF e devolve um resultado — isso é **uma transação completa** que cruza a fronteira usuário↔sistema. Logo, **cada feature (N3) é candidata a um processo elementar (PE)** e, se qualificada, conta como EE, SE ou CE.

- ✅ **Correto:** avaliar a feature (front + BFF) como um PE candidato.
- ❌ **Errado:** olhar o endpoint do BFF isoladamente e descartá-lo por ser "interno". O BFF sozinho não é um PE — mas isso **não zera** a feature que ele atende.

| Situação | Conta? |
|---|---|
| Feature (N3) que satisfaz os critérios de PE e se classifica como EE/SE/CE | **Sim** — pelo tipo |
| Feature disparada por/integrada a outro sistema, API pública, parceiro ou arquivo externo | **Sim** — pelo tipo |
| Endpoint do BFF olhado isoladamente (sem ser a feature completa) | **Não** — não é a unidade de contagem |
| Navegação, menus e telas que são apenas passos de outro PE | **Não** — não é PE |

> **Importante:** ter o backend em BFF interno **não** é, por si só, motivo para não
> contar. O que decide é se a **feature** satisfaz as regras de PE do CPM.

**Funções de Dados (ALI / AIE)** não são registradas na seção `## Métricas de tamanho` do N3 — vivem centralmente em `global/DATA-MODEL.md` e nos fragmentos `global/data-models/[dominio].md`. Ver seção *Como manter o registro de ALIs sincronizado*.

### O que contar e o que não contar no N3

Cada artefato N3 corresponde a uma única funcionalidade. Registre nele apenas as funções de transação geradas por essa funcionalidade:

| O que encontrar no N3 | Contar? | Como contar |
|---|---|---|
| ALI — entidade mantida por este sistema | **Não** | Contado centralmente no DATA-MODEL.md |
| AIE — entidade de sistema externo referenciada | **Não** | Contado centralmente no DATA-MODEL.md |
| Endpoint exposto a sistema externo (POST/PUT/PATCH/DELETE) | **Sim** | EE |
| Endpoint exposto a sistema externo (GET com transformação) | **Sim** | SE |
| Endpoint exposto a sistema externo (GET simples) | **Sim** | CE |
| Feature 100% atendida por BFF interno (sem exposição externa) | **Sim, se for PE** | EE/SE/CE pelo tipo — BFF interno não zera a feature |
| Componente que apresenta uma lista lida de um ALI ou AIE — combo, dropdown, autocomplete, carrossel, botões de categoria, chips | **Sim** | CE (sem lógica) ou SE (com lógica de filtro ou transformação) — ver *Regra da lista consultada* |
| Consulta *implícita* — a leitura que abre o formulário de edição preenchido | **Depende** | CE/SE **se** o formulário trouxer dado que a pesquisa não mostrava; **não conta** se a lista já exibia tudo |

> **Regra da lista consultada** *(antes chamada "Regra do combobox" — o nome mudou porque a combo é o exemplo, não a regra)*: sempre que um componente apresenta ao usuário uma **lista de valores lida de uma entidade marcada como ALI ou AIE**, essa recuperação é um **processo elementar** — tem início (o disparo), meio (a consulta ao arquivo lógico) e fim (a lista apresentada), e entrega valor ao usuário. O componente não importa: combo, dropdown, autocomplete, lookup, um **carrossel** que recupera e exibe uma lista, **botões de categoria** que, ao clicar, filtram outra lista, chips, árvore ou menu carregado de dados. O que decide é a **origem dos valores** — uma consulta a ALI/AIE —, não a forma de exibi-los; vale ainda que a leitura venha por endpoint BFF interno. Classifique como **CE** (sem lógica) ou **SE** (com filtro, cálculo ou transformação) e conte **uma vez na aplicação** — registrada na feature **dona da tela** onde ela foi contada primeiro (Superfície *Tela própria* ou *Modal* — o modal com conteúdo próprio: detalhe de um registro, consulta ou formulário que não é subformulário de outro), nunca numa feature de *Ação em tela*, que não tem formulário próprio. A mesma lista noutra tela não conta de novo: a linha **referencia** o PE contado (ver *PE reutilizado*, abaixo). Conferência: `node scripts/valida-acessorio-tela.mjs`. *(definição do PO, 2026-09-03; dona da tela, 2026-09-23; uma vez na aplicação, 2026-09-27)*
>
> **Nome do PE**: `Consultar <rótulo do campo> (<componente>)` — o **rótulo que a tela mostra** para a lista (o Label PO do campo na tabela `## Campos` do N3), não o nome da entidade consultada nem o da tela que a exibe; o componente entre parênteses (`combo`, `carrossel`, `botões`) é só marcação de conferência — `combo` serve para **qualquer** lista de valores lida de ALI/AIE, seja qual for o componente da tela, e o PE não se renomeia quando o componente real se revela outro (uma lista de filtros com contagem, por exemplo) *(PO, 2026-10-02)*. Ex.: `Consultar Ata sob minha gestão (combo)`, `Consultar Categorias (botões)`. A entidade lida fica no ALR da memória de cálculo e na `Observação` do consolidado. *(decisão do PO, 2026-09-23 — até então o nome era o da entidade)*: duas listas sobre a mesma entidade com filtros diferentes — as atas vigentes com item elegível numa tela, as atas sob gestão do usuário noutra — saíam com o mesmo nome, e nome igual se lê como o mesmo PE. Com o rótulo, nome igual passa a dizer **a mesma lista** (mesmo rótulo, mesmo filtro), que é o que a conferência de duplicidade do CPM 4.3.1 (5.5.1) procura — e o `valida-acessorio-tela` confere: o mesmo nome contado em duas features é erro (ver *PE reutilizado*). Rótulo igual com filtro diferente é exceção: as duas contam, a diferença vai para a `Observação` do consolidado, e uma delas a declara na memória de cálculo — `> Distinto de <ID> · <PE>: <o que difere>`. Linhas `acessório` vindas de baseline externo mantêm o nome da planilha de origem; o `principal` leva o nome da feature (ver *Papel do PE em relação à feature*). Lista alimentada por valores fixos no código, por enum ou por valores já presentes na própria tela **não** consulta ALI/AIE e **não** é PE; e o clique que só filtra, em memória, o que já está em tela também não — nada atravessa a fronteira (ver *Regra da consulta implícita*). Se o clique dispara nova consulta ao arquivo lógico com o filtro, esse é o PE da própria lista filtrada, não um segundo PE dos botões.

> **PE reutilizado** *(decisão do PO, 2026-09-27)*: um processo elementar conta **uma vez na aplicação** — pelo CPM, os mesmos DER, os mesmos arquivos lógicos e a mesma lógica são o mesmo PE, em quantas telas ele aparecer. A feature que usa um PE já contado noutra — a mesma lista noutra tela, o mesmo relatório por outro caminho — grava a linha na sua `## Métricas de tamanho` com o **nome do PE contado** e, na coluna Tipo, `↪` seguido do ID da feature onde ele conta, **com link para o N3 dela** (caminho relativo a este N3: quem lê chega ao PE contado num clique; sem o link, ou com link para outro arquivo, o `valida-acessorio-tela` reprova e diz o link a gravar); ALR, DER, Complexidade e PF ficam `—`, e a memória de cálculo não se repete:
>
> `| Consultar Empresa (combo) | — | ↪ [CRM-CTT-01](../[feature-set]/[feature].md) | — | — | — | — | 2026-09-27 |`
>
> O componente entre parênteses não entra na comparação: a mesma lista em combo numa tela e em autocomplete noutra é o mesmo PE. **A alteração vai para o PE:** a mudança na lista, venha do ticket de qualquer feature que a usa, é feita na linha contada — a recontagem, a `## Origem` e o Changelog são da feature onde o PE conta, que fica com a contagem pendente —, e as features que o reutilizam entram na AIM como regressão (o `generate-impact-draft` segue o `↪` nos dois sentidos). Se a mudança vale só para uma das telas, as listas deixam de ser iguais: a que mudou passa a contar a sua e declara a diferença (`> Distinto de …`). Se a feature onde o PE conta for deprecada, a contagem passa para uma das que o reutilizam. **Para saber se um PE já é contado:** `node scripts/valida-acessorio-tela.mjs --pe "<nome do PE>"` responde onde ele conta e quem o reutiliza; sem o `--pe`, a mesma checagem reprova o PE contado duas vezes e a referência que não acha o PE contado.

> **Regra da consulta implícita**: um processo elementar exige que os dados
> **atravessem a fronteira da aplicação**. Ao acionar *Editar* em uma linha da
> pesquisa, o formulário abre com todos os campos preenchidos — essa leitura é a
> consulta *implícita*. Ela é PE **quando traz dado que a tela de pesquisa não
> mostrava**; quando a lista tem poucas colunas e já exibe tudo o que o formulário
> edita, **nada cruza a fronteira de novo e não há o que contar**. O nome
> *(implícita)* na planilha marca a linha para conferência, nunca decide o
> resultado. Registre a decisão na coluna **Observação** do `CONTAGEM-PF.md` — uma
> linha com 0 PF sem justificativa é indistinguível de linha por preencher.
> *(critério informado por equipe de métricas, 2026-09-02)*
> **Fica sempre com a feature Editar** *(decisão do PO, 2026-09-23)*: é a leitura que abre o formulário de edição preenchido, e conta-se em `Editar <Entidade>` mesmo quando o Editar abre sobre a pesquisa, num *Modal* — nunca na Cadastrar, que abre o formulário vazio, nem na Pesquisar ou Visualizar que só a hospeda; sem feature Editar no Feature Set, vale a regra geral (dona da tela). `scripts/valida-acessorio-tela.mjs` confere.


### Papel do PE em relação à feature — `principal` × `acessório`

*(decisão do PO, 2026-09-28 — trazida do portal-compras, REP-030 e REP-053 do ledger de replicação de lá)*

A tabela de `## Métricas de tamanho` do N3 traz a coluna **Papel**, logo depois do nome do PE, que diz o que cada processo elementar é **em relação à feature**:

| Papel | O que é | Exemplo |
|---|---|---|
| `principal` | O PE que **realiza** a feature — mesma intenção primária e mesmo objeto que o nome dela. Contam como principais também as variantes do **mesmo** processo por canal (tela e API) ou por tipo do objeto (PJ, PF, estrangeiro): é a mesma função cruzando a fronteira por outro caminho. | `Pesquisar Contato`, em `CRM-CTT-01` — Pesquisar Contato |
| `acessório` | PE com intenção primária **própria**, que a feature apenas hospeda ou consome: lista consultada (combo, autocomplete, carrossel), consulta implícita que carrega a tela, exportação/impressão do mesmo conteúdo, ação vizinha na mesma tela — **desde que a ação vizinha seja principal da feature dona dela** (a tela não é a unidade: uma tela atende várias features). | `Consultar Empresa (combo)` e `Exportar Contatos Excel`, em `CRM-CTT-01` — Pesquisar Contato |

**Para que serve.** Quando a feature muda, a análise de impacto mede **os principais por padrão**. Os acessórios entram na medição **só quando o analista de métricas apontar** que aquele PE foi tocado — é ele quem identifica, caso a caso, o acessório atingido. Sem a coluna, cada análise refaz essa separação a partir do nome do PE, e o mesmo conjunto sai medido de um jeito numa sprint e de outro na seguinte.

**O papel não muda a contagem.** Ele classifica PE **já contados**: o total da feature soma principais e acessórios, como sempre. Papel responde *o que medir quando algo muda* — não *quanto vale*.

**Regras de preenchimento:**

- Toda linha **medida** (PF numérico, inclusive 0) diz `principal` ou `acessório`. A linha `↪` (PE reutilizado) e a ainda não medida (PF `—`) levam `—`: a primeira conta noutra feature, a segunda ainda não tem papel a declarar.
- Toda feature com PE contado tem **ao menos um** `principal`. Feature sem principal é sinal de que o PE que a realiza não foi contado — registre a lacuna com ⚠️ em vez de promover um acessório a principal.
- Pode haver **mais de um** principal: quando o mesmo processo aparece em mais de um canal ou variante, ou quando a tela serve a dois objetos (uma pesquisa que lista Pedidos **e** Itens, os dois principais).
- O papel é do PE **naquela feature**: o mesmo PE pode ser principal numa e acessório noutra.
- **O `principal` leva o mesmo nome da feature, sem alteração nem variação** *(decisão do PO, 2026-10-04)*: o título do N3, letra por letra — sem sufixo de componente (`(lista)`, `(combo)`), sem sinônimo do verbo (`Incluir` por `Cadastrar`), sem singular por plural. Vale também para o PE vindo de baseline externo: a planilha de origem dá o número, não o nome. Com **mais de um** principal — um por formato de exportação, um por canal, um por tipo do objeto —, cada um é o nome da feature e a variante entre parênteses: `Exportar Convênios (XLSX)`, `Exportar Convênios (ODS)`. O acessório tem nome próprio (ver *Nome do PE*, acima). O `valida-enumeracao-contagem` reprova a diferença, e é gate do hook (F11).
- **Ação vizinha é acessório só se for principal de outra feature.** Um EE com verbo próprio, "pronto" próprio e mudança de estado própria passa nos testes do `engine/FEATURE-DEFINITION.md` (teste 3: grava, atualiza ou cancela dado de negócio); se nenhuma feature o tem como principal, o que falta é a feature — ou o papel está errado —, não o registro como acessório. **EE acessório é cheiro**: o acessório legítimo é quase sempre SE ou CE (lista consultada, consulta implícita, exportação).
- **Variante por completude também é principal.** Salvar rascunho da mesma tela, com validação relaxada, tem o mesmo objeto e a mesma intenção primária (manter o ALI) do PE principal; quando a feature o especifica (regra de retomada, cenário de rascunho), ela o realiza — classifique-o principal, como as variantes por canal e por tipo do objeto.
- **O acessório mora na feature dona da tela** — ver a *Regra da lista consultada* acima e o `scripts/valida-acessorio-tela.mjs`.

**Consolidado.** O `global/CONTAGEM-PF.md` espelha a coluna em `## 1. Funções de Transação`; PE que não pertence a feature nenhuma (workflow, integração, notificação) sai com `—`.

**Conferência** — `node scripts/valida-contagem-consolidada.mjs`: **reprova** o N3 cuja tabela não tem a coluna Papel, a linha medida sem `principal` ou `acessório`, o consolidado sem a coluna e a feature cuja soma de PF dos principais diverge entre o N3 e o consolidado; **avisa** a feature contada sem nenhum `principal` (a lacuna se resolve com a equipe de métricas, não editando o arquivo) e o EE `acessório` que não é principal em feature nenhuma.

### Quem conta e quando

| Etapa | Responsável | Momento |
|---|---|---|
| Estimativa do ticket | PO / Analista de Requisitos, na AIM | Na análise do ticket, antes do aval do escopo (PROMPT_AIM, passo 5) |
| Contagem inicial | Dev que especificou o N3 técnico | Após PROMPT_3B |
| Revisão | Tech Lead do domínio | Antes de mover para `🔄 Em desenvolvimento` |
| Auditoria | Papel externo (se contratual) | Pontual, baseado nos N3 com status `✅ Implementado` |

A **estimativa do ticket** não é contagem deste documento: é a contagem estimada da AIM (`## Contagem estimada`), feita só com a função e o tipo, pelo peso fixo da aba "AFP - Estimativa" do modelo do cliente — EE 4 · CE 4 · SE 5 · ALI 7 · AIE 5. Ela fica na AIM, vai à planilha estimada (`…_PF_CE.xlsx`) e **nunca** entra no N3, no `CONTAGEM-PF.md` nem no `modules/INDEX.md`: para lá só vai a contagem detalhada, feita pelas regras acima. Quando a detalhada fecha, a AIM troca o `(E)` pelo número do N3 e guarda a estimativa ao lado, com a diferença.

---

## Conciliação Feature ↔ Processo Elementar (baseline APF)

> Rastreabilidade entre as **features (N3)** desta instância e os **processos elementares (PE)** medidos no baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB** — 647 PF: 117 de funções de dados e 530 de transações). A coluna **Processo elementar (planilha)** traz o nome do PE exatamente como consta na contagem, para auditoria cruzada.
>
> **Regra de ouro**: a planilha é a fonte da medição; esta tabela apenas registra a qual feature cada PE corresponde. Ao criar ou renomear uma feature, atualize a linha; ao recontar, reconcilie os nomes.

> **Nome do PE nesta tabela × no N3 (4.1.0)**: aqui a coluna traz o nome **da planilha**, para a auditoria cruzada com o baseline. Na `## Métricas de tamanho` do N3, o processo elementar `principal` leva o nome da feature (ver *Papel do PE em relação à feature*), com uma nota que registra o nome da planilha; os acessórios mantêm o nome de origem.

### A relação não é 1:1 — e não deveria ser

Das 110 features, **58 (53 por cento) têm correspondência exata 1:1** com um PE. As demais divergem por motivos estruturais e previsíveis, não por erro de contagem nem de especificação:

| Correspondência | Features | O que significa |
|---|---|---|
| **1:1** | 58 | Uma feature ↔ um PE de mesmo escopo |
| **N:1** | 28 | Vários PEs colapsam em uma feature — a planilha conta a carga do formulário (`Consultar X (implícita)`) e a listagem da aba como transações próprias; o docqui as trata como passos da feature de edição/configuração |
| **parcial** | 4 | O PE cobre parte do escopo da feature (ou vice-versa) |
| **compartilhado** | 1 | `VAL-ANA-04` divide com `VAL-ANA-03` o PE *Aceitar / Rejeitar Inscrição* — um PE, duas features |
| **sem PE** | 19 | A feature não tem PE no baseline (motivo indicado na linha) |

As três causas estruturais da divergência:

1. **Carga de formulário como PE** — a planilha conta `Consultar X (implícita)` (16 ocorrências) como transação separada da edição. No docqui, carregar o registro é passo da feature `Editar X`, não feature própria.
2. **Combos contam, mas não são features** — pela *Regra da lista consultada* deste documento, cada consulta de apoio a campo de seleção conta como CE. São **9 PEs** legítimos na medição que, por definição, não viram N3 (são passos de outra tela).
3. **Granularidade de configuração** — abas como *Configuração de Anexos* e *Configuração de Equipe* têm 5 PEs cada (listar, incluir, consultar, editar e desativar) que o docqui documenta como uma única feature `Configurar …`.

> **Conclusão para a contagem**: manter a planilha como unidade de medição (PE) e esta tabela como ponte. Forçar 1:1 exigiria ou fatiar features em CRUDs de sub-entidade (perdendo a leitura de negócio) ou deixar de contar transações que o CPM manda contar.

### Registro por feature

| Feature (N3) | Nome da feature | Processo elementar (planilha) | Tipo | PF | Correspondência |
|---|---|---|---|---|---|
| `ACS-ACE-01` | Autenticar Usuário | — *(LOGON — não contado; regra CAIXA 7)* | — | — | sem PE |
| `ACS-ACE-02` | Consultar Perfil do Usuário | — *(derivada da sessão; sem PE no baseline)* | — | — | sem PE |
| `ACS-ADM-01` | Pesquisar Administradores | Pesquisar Usuários | CE | 3 | 1:1 |
| `ACS-ADM-02` | Cadastrar Administrador Regional | Incluir Usuário | EE | 3 | 1:1 |
| `ACS-ADM-03` | Editar Administrador Regional | Editar Usuário (+1) | EE | 6 | N:1 |
| `ACS-ADM-04` | Vincular UF ao Administrador | — *(passo dentro de cadastrar/editar administrador)* | — | — | sem PE |
| `ACS-AUD-01` | Consultar Trilha de Auditoria | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `AVL-ALO-01` | Consultar Alocação de Avaliadores | Consultar Alocação de Avaliadores | SE | 7 | 1:1 |
| `AVL-ALO-02` | Alocar Avaliador ao Grupo | Salvar Pool | EE | 3 | 1:1 |
| `AVL-ALO-03` | Cadastrar Avaliador | Cadastrar Avaliador | EE | 4 | 1:1 |
| `AVL-ALO-04` | Alocar Avaliador à Inscrição | Incluir Avaliadores para Inscrição (+2) | EE/SE | 17 | N:1 |
| `AVL-APU-01` | Apurar Resultado da Etapa | Apurar Resultado da Etapa *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 7 | 1:1 |
| `AVL-APU-02` | Registrar Desempate | Registrar Desempate *(contado em 2026-09-01, fora do baseline ⚠️)* | EE | 6 | 1:1 |
| `AVL-APU-03` | Encerrar Etapa por UF | Encerrar Etapa por UF *(contado em 2026-09-01, fora do baseline ⚠️)* | EE | 6 | 1:1 |
| `AVL-APU-04` | Gerar Devolutiva com IA | Gerar com IA | SE | 4 | 1:1 |
| `AVL-APU-05` | Revisar Devolutiva | Revisar Devolutiva *(contado em 2026-09-01, fora do baseline ⚠️)* | EE | 6 | 1:1 |
| `AVL-APU-06` | Gerar Relatório de Inscrições Paradas | Relatório de Inscrições Paradas (+1) | SE | 14 | N:1 |
| `AVL-APU-08` | Consultar Ranking da Etapa | Consultar Ranking da Etapa *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 7 | 1:1 |
| `AVL-APU-09` | Exportar Relatório da Etapa | Exportar Relatório da Etapa *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 7 | 1:1 |
| `AVL-APU-10` | Gerar Relatório de Inscrições | Consultar Relatório de Inscrições (+1) *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 14 | N:1 |
| `AVL-APU-12` | Reabrir Etapa por UF | Reabrir Etapa por UF *(contado em 2026-09-01, fora do baseline ⚠️)* | EE | 4 | 1:1 |
| `AVL-AVA-01` | Acompanhar Minhas Avaliações | Consultar Painel Minhas Avaliações | SE | 7 | 1:1 |
| `AVL-AVA-02` | Aceitar Termo de Confidencialidade | Aceitar Termo de Aceite (+2) | CE/EE | 9 | N:1 |
| `AVL-AVA-03` | Avaliar Inscrição | Salvar Avaliação (+1) | EE/SE | 10 | N:1 |
| `AVL-AVA-04` | Finalizar Avaliação | Finalizar Avaliação | EE | 3 | 1:1 |
| `AVL-AVA-05` | Reabrir Avaliação | Reabrir Avaliação | EE | 3 | 1:1 |
| `AVL-ETA-01` | Configurar Avaliação | Alterar Configurações Avaliações e Etapas (+1) | EE/SE | 8 | N:1 |
| `AVL-ETA-02` | Cadastrar Etapa | Cadastrar Nova Etapa | EE | 3 | 1:1 |
| `AVL-ETA-03` | Editar Etapa | Editar Etapa (+1) | CE/EE | 3 | N:1 |
| `AVL-ETA-04` | Excluir Etapa | Excluir Etapa | EE | 3 | 1:1 |
| `AVL-ETA-05` | Reordenar Etapas | Alterar ordem das etapas | EE | 3 | 1:1 |
| `AVL-ETA-06` | Configurar Critérios de Desempate | Configurar Critérios de Desempate (+1) | CE/EE | 6 | N:1 |
| `AVL-ETA-07` | Configurar Termo de Confidencialidade | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `AVL-PAI-01` | Acompanhar Painel de Avaliações | Consultar Painel de Avaliações | SE | 7 | 1:1 |
| `AVL-PAI-02` | Consultar Avaliações por Etapa | Consultar Avaliações por Etapa (+1) | SE | 11 | N:1 |
| `AVL-PAI-03` | Consolidar Avaliação | Consolidar Avaliação (+1) | CE/EE | 6 | N:1 |
| `AVL-PAI-04` | Exportar Relatório de Avaliadores | Exportar Relatório de Avaliadores *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 7 | 1:1 |
| `CFG-CAT-01` | Pesquisar Categorias | Pesquisar Categorias | SE | 5 | 1:1 |
| `CFG-CAT-02` | Cadastrar Categoria | Incluir Categoria | EE | 3 | 1:1 |
| `CFG-CAT-03` | Editar Categoria | Editar Categoria (+1) | EE/SE | 8 | N:1 |
| `CFG-CAT-04` | Visualizar Categoria | Detalhar Categoria | SE | 0 | 1:1 |
| `CFG-CAT-05` | Ativar/Inativar Categoria | Ativar/Inativar Categoria | EE | 3 | 1:1 |
| `CFG-EMA-01` | Consultar Modelos de E-mail | Consultar Template de E-mail (implícita) | CE | 3 | 1:1 |
| `CFG-EMA-02` | Editar Modelo de E-mail | Editar Template de E-mail | EE | 3 | 1:1 |
| `CFG-EMA-03` | Visualizar E-mail | Visualizar E-mail | CE | 3 | 1:1 |
| `CFG-LIS-01` | Pesquisar Listas | Pesquisar Listas do Sistema | CE | 3 | 1:1 |
| `CFG-LIS-02` | Cadastrar Lista | Incluir Lista do Sistema | EE | 3 | 1:1 |
| `CFG-LIS-03` | Editar Lista | Editar Lista do Sistema (+1) | CE/EE | 6 | N:1 |
| `CFG-LIS-04` | Excluir Lista | Excluir Lista do Sistema | EE | 3 | 1:1 |
| `CFG-LIS-05` | Configurar Itens da Lista | Ordenar Lista | EE | 3 | parcial |
| `CFG-MOD-01` | Pesquisar Modalidades | Pesquisar Modalidade | CE | 4 | 1:1 |
| `CFG-MOD-02` | Cadastrar Modalidade | Incluir Modalidade | EE | 3 | 1:1 |
| `CFG-MOD-03` | Editar Modalidade | Editar Modalidade (+1) | EE/SE | 8 | N:1 |
| `CFG-MOD-04` | Visualizar Modalidade | Detalhar Modalidade |  | 0 | 1:1 |
| `CFG-MOD-05` | Ativar/Inativar Modalidade | Ativar/Inativar Modalidade | EE | 3 | 1:1 |
| `CFG-PRE-01` | Pesquisar Prêmios | Pesquisar Premiações | SE | 4 | 1:1 |
| `CFG-PRE-02` | Cadastrar Prêmio | Incluir Prêmio | EE | 3 | 1:1 |
| `CFG-PRE-03` | Editar Prêmio | — *(edição do prêmio diluída nas abas de "Gerenciar Prêmio" ⚠️)* | — | — | sem PE |
| `CFG-PRE-04` | Ativar/Inativar Prêmio | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-PRE-05` | Exportar Prêmios | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-PRE-06` | Importar Prêmios | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-PRE-07` | Gerar Link Público | Gerar Novo Link | EE | 6 | 1:1 |
| `CFG-PRE-08` | Consultar Links Públicos | Consultar Links Públicos de Inscrição | CE | 3 | 1:1 |
| `CFG-PRE-09` | Cadastrar Termo de Aceite | Incluir Termo de Aceite (+1) | CE/EE | 6 | N:1 |
| `CFG-PRE-10` | Editar Termo de Aceite | Editar Termo de Aceite (+1) | CE/EE | 6 | N:1 |
| `CFG-PRE-11` | Excluir Termo de Aceite | Excluir Termo de Aceite | EE | 3 | 1:1 |
| `CFG-PRE-12` | Configurar Critérios de Avaliação | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-TIP-01` | Pesquisar Tipos de Participante | Pesquisar Tipo de Participante | SE | 4 | 1:1 |
| `CFG-TIP-02` | Cadastrar Tipo de Participante | Incluir Tipo de Participante | EE | 3 | 1:1 |
| `CFG-TIP-03` | Editar Tipo de Participante | Editar Tipo de Participante (+1) | EE/SE | 10 | N:1 |
| `CFG-TIP-04` | Visualizar Tipo de Participante | Detalhar Tipo de Participante | SE | 0 | 1:1 |
| `CFG-TIP-05` | Ativar/Inativar Tipo de Participante | Ativar/Inativar Tipo de Participante | EE | 3 | 1:1 |
| `CFG-TIP-06` | Configurar Formulário de Inscrição | Configurar Estrutura do Formulário de Inscrição (+1) | CE/EE | 9 | N:1 |
| `CFG-TIP-07` | Cadastrar Campo | Adicionar Campo | EE | 4 | 1:1 |
| `CFG-TIP-08` | Editar Campo | Editar Campo (+1) | CE/EE | 10 | N:1 |
| `CFG-TIP-09` | Excluir Campo | Excluir Campo | EE | 3 | 1:1 |
| `CFG-TIP-10` | Cadastrar Enquadramento | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-TIP-11` | Ativar/Inativar Enquadramento | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `CFG-TIP-12` | Configurar Anexos Exigidos | Listar Configuração de Anexos (+4) | CE/EE | 21 | N:1 |
| `CFG-TIP-13` | Cadastrar Questão | Incluir Questão do Questionário Avaliação (+1) | CE/EE | 9 | N:1 |
| `CFG-TIP-14` | Editar Questão | Editar Questão do Questionário Avaliação (+1) | CE/EE | 9 | N:1 |
| `CFG-TIP-15` | Configurar Equipe | Listar Configuração de Equipe (+4) | CE/EE | 17 | N:1 |
| `CFG-TIP-16` | Importar Configuração do Tipo de Participante | Importar Configuração Excel | EE | 6 | 1:1 |
| `CFG-VIN-01` | Consultar Estrutura da Premiação | Consultar Categorias (lista/pesquisa) (+1) | CE | 6 | N:1 |
| `CFG-VIN-02` | Vincular Categoria | Criar e Vincular Categoria (+1) | EE | 6 | N:1 |
| `CFG-VIN-03` | Desvincular Categoria | Desvincular Categoria | EE | 3 | 1:1 |
| `CFG-VIN-04` | Vincular Modalidade | Criar e Vincular Modalidade (+1) | EE | 7 | N:1 |
| `CFG-VIN-05` | Desvincular Modalidade | Desvincular Modalidade | EE | 3 | 1:1 |
| `CFG-VIN-06` | Vincular Tipo de Participante | Copiar Tipo de Participante | EE | 4 | parcial |
| `CFG-VIN-07` | Desvincular Tipo de Participante | Desvincular Tipo de Participante | EE | 3 | 1:1 |
| `CFG-VIN-08` | Duplicar Oferta | Duplicar Categoria (+2) | EE | 12 | N:1 |
| `CFG-VIN-09` | Cadastrar Submodalidade | Incluir Submodalidades (+1) | CE/EE | 7 | N:1 |
| `CFG-VIN-10` | Editar Submodalidade | Editar Submodalidade (+1) | CE/EE | 7 | N:1 |
| `CFG-VIN-11` | Ativar/Inativar Submodalidade | Ativar/Desativar Submodalidade | EE | 3 | 1:1 |
| `INS-ACO-01` | Acompanhar Inscrição | Consultar Dashboard do Participante | SE | 7 | 1:1 |
| `INS-ACO-02` | Visualizar Devolutiva | — *(sem PE no baseline ⚠️)* | — | — | sem PE |
| `INS-NOT-01` | Consultar Notificações | Consultar Notificações | SE | 4 | 1:1 |
| `INS-NOT-02` | Marcar Notificação como Lida | Marcar Notificação como Lida | EE | 3 | 1:1 |
| `INS-PAR-01` | Cadastrar Inscrição | Realizar Inscrição (Rascunho) | EE | 6 | 1:1 |
| `INS-PAR-02` | Editar Inscrição | Editar Inscrição | EE | 6 | 1:1 |
| `INS-PAR-03` | Finalizar Inscrição | Finalizar Inscrição | EE | 3 | 1:1 |
| `INS-PAR-04` | Reenviar Inscrição | Reenviar Inscrição (+1) | EE | 3 | N:1 |
| `INS-PAR-05` | Anexar Documento | — *(passo dentro de cadastrar/editar inscrição)* | — | — | sem PE |
| `INS-PAR-06` | Aceitar Termo | Consultar Termo de Aceite | CE | 3 | parcial |
| `INS-PAR-07` | Retomar Inscrição | — *(passo dentro de cadastrar inscrição (retomar rascunho))* | — | — | sem PE |
| `VAL-AJU-01` | Solicitar Ajuste | Solicitar Ajuste | EE | 6 | 1:1 |
| `VAL-AJU-02` | Consultar Auditoria de Ajustes | Consultar Auditoria de Ajustes | SE | 5 | 1:1 |
| `VAL-AJU-03` | Exportar Auditoria de Ajustes | Exportar Auditoria de Ajustes para CSV | CE | 4 | 1:1 |
| `VAL-ANA-01` | Detalhar Inscrição | Detalhar Inscrição | SE | 7 | 1:1 |
| `VAL-ANA-02` | Iniciar Validação | Iniciar Validação da Inscrição | EE | 3 | 1:1 |
| `VAL-ANA-03` | Aprovar Inscrição | Aceitar / Rejeitar Inscrição | EE | 6 | parcial |
| `VAL-ANA-04` | Rejeitar Inscrição | Aceitar / Rejeitar Inscrição | EE | 0 | compartilhado |
| `VAL-ANA-05` | Editar Inscrição Validada | Editar Inscrição Validada *(contado em 2026-09-01, fora do baseline ⚠️)* | EE | 6 | 1:1 |
| `VAL-FIL-01` | Pesquisar Inscrições para Validação | Consultar Dashboard Validação de Inscrições | SE | 7 | 1:1 |
| `VAL-FIL-02` | Acompanhar Painel de Validação | Consultar Dashboard Gerencial | SE | 7 | 1:1 |
| `VAL-FIL-03` | Exportar Histórico do Painel de Validação | Exportar Histórico do Painel de Validação *(contado em 2026-09-01, fora do baseline ⚠️)* | SE | 7 | 1:1 |

### Processos elementares sem feature correspondente

Os **12 PEs** abaixo não têm N3. Nove são combos (esperado — não são features); **três são lacunas reais da especificação**:

| Processo elementar (planilha) | Tipo | PF | Por que não é feature |
|---|---|---|---|
| Consultar Categorias (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Visualizar Preview do Formulário | CE | 6 | ⚠️ **lacuna da spec** — não existe N3 correspondente |
| Consultar Premiação (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Categoria por Premiação (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Modalidade por Categoria (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Tipo de Participante por Modalidade (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Rodadas (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Editar Inscrição | EE | 6 | ⚠️ **lacuna da spec** — não existe N3 correspondente |
| Excluir Inscrição | EE | 3 | ⚠️ **lacuna da spec** — não existe N3 correspondente |
| Consultar Etapa por Premiação (combo) | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Grupo (combo) | CE | 4 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |
| Consultar Etapas por Inscrição | CE | 3 | consulta de apoio a campo de seleção — não é feature no docqui (é passo de outra tela) |

> As lacunas `Editar Inscrição` e `Excluir Inscrição` (edição administrativa da inscrição validada) já estão registradas como pendência no relatório de impacto da SP05 — features propostas `VAL-ANA-05` e `VAL-ANA-06`. A lacuna `Visualizar Preview do Formulário` não tem feature proposta ainda. ⚠️

### Features sem PE no baseline — o que investigar

Das 19 features sem PE, quatro grupos explicam o conjunto:

- **Não contabilizável por norma** (1): `ACS-ACE-01` Autenticar Usuário — LOGON, regra 7 das *Regras de medição de serviços* acima.
- **Passo de outra feature** (3): `ACS-ADM-04`, `INS-PAR-05`, `INS-PAR-07` — o baseline as absorveu na transação principal.
- **Módulo de fechamento fora do baseline** (4) ⚠️: `AVL-APU-01/02/03/05` (apuração, desempate, encerramento por UF, revisão de devolutiva). O baseline é **anterior à SP05**, e o fechamento da etapa é justamente o que a sprint entrega — estas quatro não existiam quando a contagem foi feita, então entram como **funções incluídas na contagem da própria SP05**, não como lacuna do baseline. Ver Q4 do questionamento à métrica.
- **Ausências a confirmar com a métrica** (11) ⚠️: `ACS-ACE-02`, `ACS-AUD-01`, `AVL-ETA-07`, `CFG-PRE-03/04/05/06/12`, `CFG-TIP-10/11`, `INS-ACO-02`. Chama atenção `CFG-PRE-03` **Editar Prêmio** — a planilha conta *Incluir Prêmio* mas nenhuma edição, provavelmente porque a edição do prêmio está diluída nas abas de *Gerenciar Prêmio*.

---

## Consolidação no INDEX.md

O `modules/INDEX.md` deve manter os totais acumulados por feature, domínio e sistema:

```markdown
| Feature | Domínio | Status | PF | CFP |
|---|---|---|---|---|
| [Feature] | [Domínio] | ✅ Implementado | 12 | 18 |
```

Totais de domínio e sistema são calculados por soma das features com status `📋 Especificado`, `🔄 Em desenvolvimento` e `✅ Implementado`. Features `❌ Deprecadas` são excluídas do total vigente mas mantidas no histórico.

---

## Glossário rápido

| Sigla | Significado |
|---|---|
| APF | Análise de Pontos de Função |
| PF | Ponto de Função |
| ALI | Arquivo Lógico Interno |
| AIE | Arquivo de Interface Externa |
| EE | Entrada Externa |
| SE | Saída Externa |
| CE | Consulta Externa |
| DER | Dado Elementar Referenciado — campo (IFPUG: **DET**, *Data Element Type*) |
| RLR | Registro Lógico Referenciado — subgrupo lógico de uma função de dados (IFPUG: **RET**, *Record Element Type*) |
| ALR | Arquivo Lógico Referenciado — ALI/AIE lido ou mantido por uma transação (IFPUG: **FTR**, *File Type Referenced*) |
| COSMIC | Common Software Measurement International Consortium |
| CFP | COSMIC Function Point |
| E | Entry (movimento COSMIC) |
| X | Exit (movimento COSMIC) |
| R | Read (movimento COSMIC) |
| W | Write (movimento COSMIC) |

---

*Última revisão: 2026-06-05 — incorporadas as orientações do Capítulo 2 (Medição de Serviços em APF) do Guia de Orientação de Métricas.*

*Links: [MASTER.md](./MASTER.md) · [DATA-MODEL.md](./DATA-MODEL.md) · [INDEX geral](../modules/INDEX.md)*

---

## Como manter o registro de ALIs sincronizado

O registro central de ALIs vive em `global/DATA-MODEL.md → ## Arquivos Lógicos (APF)`. A fonte de cálculo vive nos fragmentos `global/data-models/[dominio].md → ## Arquivos Lógicos deste domínio`.

Fluxo de atualização:

```
Nova entidade criada (PROMPT_3B)
          │
          ├─→ Definir a qual ALI pertence
          │        ├─ ALI existente → anotar cabeçalho da entidade + recalcular DER/RLR
          │        └─ ALI novo      → criar linha no fragmento + anotar cabeçalho
          │
          ├─→ Atualizar seção "## Arquivos Lógicos" no fragmento data-models/[dominio].md
          │
          └─→ Atualizar linha correspondente em DATA-MODEL.md → ## Arquivos Lógicos (APF)
```

Regra de ouro: **DATA-MODEL.md é o índice; os fragmentos são a fonte de cálculo.** Nunca atualizar um sem atualizar o outro.
