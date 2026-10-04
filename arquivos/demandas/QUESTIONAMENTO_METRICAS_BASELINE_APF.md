<!-- docqui: questionamento à equipe de métricas | fonte: PIEL_BASELINE_PF_CD.xlsx + conciliação SIZING.md | gerado: 2026-08-27 -->
# Questionamento à Equipe de Métricas — Baseline APF do Prêmio IEL

> **Para**: equipe de métricas responsável pela contagem `PIEL_BASELINE_PF_CD.xlsx` (aba *AFP - Detalhada*).
> **De**: equipe de especificação de requisitos do Prêmio IEL (documentação docqui).
> **Assunto**: dúvidas levantadas ao conciliar as 110 features especificadas com os 139 processos elementares medidos.
> **Norma de referência**: IFPUG CPM 4.3.1 (ISO/IEC 20926) e as *Regras de medição de serviços* registradas em `global/SIZING.md`.

---

## Contexto

Concluímos a especificação funcional do Prêmio IEL em 110 features (nível N3), organizadas em 5 domínios e 21 Feature Sets, e a cruzamos linha a linha com a contagem do baseline. O resultado da conciliação está registrado em `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar* e é reproduzível a partir da planilha.

A conciliação fechou bem na maior parte: dos 139 processos elementares medidos, todos foram atribuídos a uma feature ou justificados como consulta de apoio. Restaram, porém, **dez pontos que não conseguimos resolver sozinhos** — eles dependem de decisões de contagem que só a equipe de métricas pode confirmar. Este documento os organiza em quatro blocos.

Nenhuma das perguntas abaixo pressupõe erro na contagem. Em vários casos suspeitamos que a resposta seja "está correto, e o motivo é X" — o que precisamos é registrar esse X na documentação, para que a próxima contagem e a próxima sprint partam da mesma base.

### Números de partida

| Indicador | Valor |
|---|---|
| PF Bruto (coluna PFB) | 647 |
| PF Fábrica de Software (coluna PFL) | ~~502,5~~ — coluna descartada, ver Bloco A |
| Funções de transação medidas | 139 (73 EE · 38 CE · 26 SE · 2 sem tipo) — 530 PF |
| Funções de dados medidas | 12 ALIs — 117 PF |
| Features especificadas (N3) | 110 |

---

## Bloco A — Deduções entre PF Bruto e PF Fábrica de Software ✅ RESPONDIDO

> **Resposta da equipe de métricas (2026-08-28): a coluna *PF Fábrica de Software* (PFL) estava com falha de preenchimento. Deve ser desconsiderada — vale o PF Bruto (PFB).**
>
> Com isso, as três perguntas deste bloco perdem objeto: não há dedução a explicar, porque a diferença de 144,5 PF não era um critério contratual, era erro de planilha. O baseline do sistema é de **647 PF**, e não 502,5. As perguntas ficam registradas abaixo como memória do que motivou a consulta; a análise que as embasava está preservada, mas **nenhum número deste bloco deve ser usado**.
>
> **Efeito na documentação** (já aplicado): o `global/DATA-MODEL.md` passa a registrar 117 PF nos 12 ALIs (era 92,5); os ALIs do domínio Avaliação deixam de aparecer zerados (*Avaliação de Inscrição* 10 PF, *Alocação Avaliadores* 7 PF) e o ALI *Premiação* volta aos 15 PF da Tabela 1 do CPM (era 7,5). O `modules/INDEX.md` e o `global/SIZING.md` passam a citar apenas o PFB.

<details><summary>Perguntas originais deste bloco (mantidas como registro)</summary>

Identificávamos a diferença de 144,5 PF entre as duas colunas concentrada em grupos definidos pela coluna **Insumo**, e reconstruímos a conta assim:

| Origem da dedução | Linhas | PF Bruto | PF Fábrica | Deduzido |
|---|---|---|---|---|
| Insumos 41, 42, 43 e 45 (módulo Avaliação) | 27 | 115 | 0 | 115 |
| ALI *Avaliação de Inscrição* (sem código de insumo) | 1 | 10 | 0 | 10 |
| Insumo 44 (validação e ajustes da inscrição) | 6 | 39 | 27 | 12 |
| Insumo 47 (ALI *Premiação* e correlatos) | 4 | 24 | 16,5 | 7,5 |
| **Total** | **38** | **188** | **43,5** | **144,5** |

### Q1 — Por que o módulo Avaliação inteiro está zerado na coluna PF Fábrica de Software? ✅

São **125 PF** zerados: 27 transações (etapas, alocação de avaliadores, painel administrativo e painel do avaliador) mais os dois ALIs do domínio (*Avaliação de Inscrição* e *Alocação Avaliadores*). Todas as linhas têm tipo, DER, ALR e complexidade preenchidos, e receberam PF Bruto normalmente — o zero aparece só na coluna final.

Nossa leitura é que essas funções foram medidas aqui mas **faturadas em outra ordem de serviço**, identificada pelos códigos de insumo 41, 42, 43 e 45. Pedimos confirmação de três pontos: (a) essa leitura está correta? (b) qual é a OS/contrato que absorveu esses 125 PF, para podermos referenciá-la na documentação? (c) o ALI *Avaliação de Inscrição*, que está sem código de insumo mas também zerado, segue o mesmo destino?

Essa é a pergunta mais importante do documento, porque hoje a nossa documentação de modelo de dados registra o domínio Avaliação como "PF pendente", o que é impreciso: os PF existem e estão calculados — apenas não foram cobrados nesta entrega.

> **Resposta**: nem uma coisa nem outra — a coluna estava com falha de preenchimento. Os 125 PF não foram faturados em outra OS; simplesmente não deveriam constar como zero. Vale o PF Bruto.

### Q2 — Qual o critério da dedução de 50% no insumo 44? ✅

Cinco transações do fluxo de validação e ajuste da inscrição (*Aceitar / Rejeitar Inscrição*, *Consultar Auditoria de Ajustes*, *Consultar Rodadas*, *Exportar Auditoria de Ajustes para CSV* e *Solicitar Ajuste*) tiveram o PF reduzido exatamente à metade. Supomos tratar-se de **função alterada** e não incluída — o que, pela fórmula de projeto de melhoria do CPM (`EFP = ADD + CHGA + CFP + DEL`), entraria como CHGA. Confirmam? Se sim, qual o percentual contratual aplicado a função alterada, e ele é o mesmo para EE, SE e CE?

> **Resposta**: não há critério — a redução à metade era efeito da mesma falha de preenchimento da coluna. As cinco transações valem o PF Bruto integral.

### Q3 — A mesma dedução de 50% no ALI *Premiação* (insumo 47) tem a mesma origem? ✅

O ALI *Premiação* foi contado com DER 71 e RLR 9, o que pela Tabela 1 do CPM dá complexidade Alta e 15 PF — e é exatamente o PF Bruto registrado. Na coluna final aparece 7,5. Presumimos o mesmo critério de função alterada da Q2. Confirmam? Havendo diferença de critério entre função de dados e função de transação, pedimos o registro.

> **Resposta**: mesma origem da Q2 — falha de preenchimento. A Premiação vale os **15 PF** do bruto, coerentes com a Tabela 1 do CPM para RLR 9 × DER 71.

</details>

---

## Bloco B — Features especificadas que não têm processo elementar na contagem

Aqui a situação é diferente do Bloco A: não se trata de linha zerada, e sim de **linha inexistente**. São funcionalidades que documentamos como features e para as quais não localizamos nenhum processo elementar correspondente na planilha.

### Q4 — O fechamento da etapa foi contado em algum lugar?

Quatro features do domínio Avaliação não têm linha na contagem:

| Feature | O que faz |
|---|---|
| `AVL-APU-01` Apurar Resultado da Etapa | Calcula média ponderada, ordena o ranking e aplica a linha de corte |
| `AVL-APU-02` Registrar Desempate | Decisão manual de desempate, com justificativa, gravada em entidade própria |
| `AVL-APU-03` Encerrar Etapa por UF | Fecha o estado, grava responsável e data, libera os classificados |
| `AVL-APU-05` Revisar Devolutiva | Revisão humana do feedback consolidado antes da liberação |

Pelos quatro critérios de processo elementar do CPM (atividade significativa para o usuário, transação completa, autocontida e que deixa o negócio em estado consistente), entendemos que as quatro qualificam — e as três primeiras mantêm ALI, o que as classificaria como EE, enquanto a apuração, por produzir dado derivado (média e colocação), tenderia a SE. O modelo físico confirma que existem: há tabelas dedicadas de apuração por etapa, decisão de desempate e fechamento de etapa por UF.

Pergunta: essas funções foram contadas em outro artefato (talvez o mesmo que absorveu os insumos 41 a 45), ou são de fato uma lacuna do baseline? Precisamos saber para não pedir a contagem em duplicidade.

> **Atualização.** A equipe do projeto confirmou que **o baseline é anterior à SP05**. Isso muda a natureza da pergunta: as quatro features não são lacuna do baseline — elas não existiam quando a contagem foi feita, e devem entrar como **funções incluídas (ADD) na contagem da própria SP05**. Resta saber apenas se já foram contadas em algum artefato dessa sprint. Ver o *Anexo — Funções de dados a contar na evolução da SP05*.

### Q5 — Onde está a alteração da Premiação?

A planilha registra *Incluir Prêmio* (EE, 3 PF) e não registra nenhuma transação de alteração do prêmio. Como a Premiação é um ALI mantido pelo sistema, e alterar o cadastro é uma operação corrente do Administrador Nacional, esperávamos uma EE de alteração.

Nossa hipótese é que a edição do prêmio esteja **diluída nas abas do módulo Gerenciar Prêmio** — isto é, que as transações de configuração (termos de aceite, links públicos, vínculos de categoria, formulário) tenham sido entendidas como a forma de alterar a premiação, sem uma EE de "editar dados básicos". Se for isso, tudo bem — mas gostaríamos de registrar a decisão, porque documentamos `CFG-PRE-03` Editar Prêmio como feature e ela ficará permanentemente sem PF.

### Q6 — Confirmação sobre nove ausências menores

As features abaixo também não têm processo elementar. Para cada uma indicamos a nossa hipótese; pedimos apenas um "confere" ou a correção:

| Feature | Nossa hipótese |
|---|---|
| `ACS-ACE-01` Autenticar Usuário | Não contável — LOGON, conforme a regra 7 das *Regras de medição de serviços* |
| `ACS-ACE-02` Consultar Perfil do Usuário | Derivada da sessão; sem transação própria |
| `ACS-ADM-04` Vincular UF ao Administrador | Passo dentro de *Incluir/Editar Usuário*, não PE autônomo |
| `ACS-AUD-01` Consultar Trilha de Auditoria | Não previsto no escopo contado? |
| `AVL-ETA-07` Configurar Termo de Confidencialidade | Absorvido em outra transação de configuração? |
| `CFG-PRE-04` Ativar/Inativar Prêmio | Absorvido na alteração do prêmio (ver Q5)? |
| `CFG-PRE-05` / `CFG-PRE-06` Exportar / Importar Prêmios | Fora do escopo contado? |
| `CFG-PRE-12` Configurar Critérios de Avaliação | Absorvido na configuração do questionário? |
| `CFG-TIP-10` / `CFG-TIP-11` Cadastrar / Ativar Enquadramento | Absorvido em *Editar Tipo de Participante*? |
| `INS-ACO-02` Visualizar Devolutiva | Parte do dashboard do participante? |

---

## Bloco C — Processos elementares medidos com PF igual a zero

### Q7 — As cinco linhas sem tipo e sem complexidade foram descartadas de propósito? ⏳ RESPONDIDA EM PARTE

Cinco linhas aparecem na planilha com o nome do processo preenchido, mas sem DER, sem ALR, sem complexidade e com PF zero:

| Linha | Processo elementar | Tipo registrado |
|---|---|---|
| 19 | Detalhar Categoria | SE |
| 26 | Detalhar Modalidade | *(em branco)* |
| 33 | Detalhar Tipo de Participante | SE |
| 104 | Realizar Ajuste na Inscrição | *(em branco)* |
| 128 | Consultar Etapa (implícita) | CE |

Há duas leituras possíveis e elas levam a conclusões opostas. Na primeira, a equipe avaliou e **descartou** essas transações — por exemplo, por entender que "detalhar" não acrescenta lógica sobre a consulta já contada, ou que a segunda ocorrência da mesma janela não é PE novo. Na segunda, são linhas que **ficaram por preencher**.

A distinção importa para nós porque `CFG-CAT-04`, `CFG-MOD-04` e `CFG-TIP-04` (as telas de visualização) estão especificadas como features e hoje aparecem com 0 PF na nossa rastreabilidade. Se o descarte foi deliberado, registramos a justificativa e encerramos o assunto; se foi lacuna, essas linhas precisam de complexidade.

Observamos ainda que *Realizar Ajuste na Inscrição* (linha 104) descreve a correção feita pelo participante após uma solicitação de ajuste — uma operação que mantém o ALI Inscrição e nos parece qualificar como EE.

#### ⏳ Resposta parcial recebida em 2026-09-02 — cobre a linha 128

O descarte da linha 128 foi **deliberado**, e o critério é o de fronteira: um processo elementar exige que os dados **atravessem a fronteira da aplicação**. A consulta marcada como *(implícita)* é a leitura que precede a edição — a tela de pesquisa mostra algumas colunas e, ao acionar Editar, o formulário abre com todos os campos preenchidos. Ela é PE quando essa abertura traz dado que a pesquisa não mostrava; **não é** quando a lista já exibia tudo. Na etapa as colunas eram poucas e os dados já estavam em tela, então nada cruza a fronteira de novo.

O critério é coerente com o resto da planilha: das **15 linhas marcadas *(implícita/implícito)*, 14 foram contadas** (3 a 7 PF) e só a 128 ficou zerada — o marcador nunca significou "não conta", significa "conferir se algo novo aparece".

O critério está registrado na coluna **Observação** de `global/CONTAGEM-PF.md`, criada para isso.

**Segue em aberto**: as quatro linhas restantes (19, 26, 33 e 104). As três primeiras são telas de *detalhar*, e o mesmo raciocínio de fronteira **pode** explicá-las — se o detalhe não mostra nada além da lista, não há PE —, mas isso é dedução nossa e não a aplicamos por conta própria; `CFG-CAT-04`, `CFG-MOD-04` e `CFG-TIP-04` continuam com 0 PF até a confirmação. A linha 104 é de outra natureza e permanece como está descrito acima.

---

## Bloco D — Confirmações de critério

Estas duas perguntas não mudam o total; servem para alinhar o vocabulário entre a contagem e a especificação.

### Q8 — Três processos medidos não têm feature especificada — confirmam que existem em produção?

O caminho inverso também produziu achados. Três processos elementares foram medidos e **não** têm feature correspondente na nossa documentação:

| Processo elementar | Tipo | PF | Situação |
|---|---|---|---|
| Editar Inscrição (contexto de validação) | EE | 6 | Edição administrativa da inscrição já validada |
| Excluir Inscrição | EE | 3 | Exclusão administrativa |
| Visualizar Preview do Formulário | CE | 6 | Pré-visualização do formulário dinâmico |

As duas primeiras já reconhecemos como lacuna nossa e estão previstas para especificação. A terceira ainda não. Como a contagem é evidência de que a funcionalidade foi entregue, pedimos confirmação de que as três estão em produção — em caso positivo, abriremos as features correspondentes.

### Q9 — A regra de contagem de combos está estabilizada?

Nove processos elementares são consultas de apoio a campos de seleção (*Consultar Categorias (combo)*, *Consultar Premiação (combo)*, *Consultar Grupo (combo)* e similares), somando 28 PF. Eles foram contados como CE, o que é coerente com a *Regra do combobox* registrada em `global/SIZING.md`.

Do nosso lado esses carregamentos não viram feature — são passos de outra tela. Isso não é divergência, mas queremos confirmar que a regra permanece válida para as próximas contagens, porque ela responde por parte da diferença entre 139 processos elementares e 110 features.

### Q10 — Uma transação, duas features: como tratar na próxima contagem?

O processo elementar *Aceitar / Rejeitar Inscrição* (EE, 6 PF) corresponde, na nossa especificação, a **duas** features: `VAL-ANA-03` Aprovar Inscrição e `VAL-ANA-04` Rejeitar Inscrição. Entendemos a contagem como correta — aprovar e rejeitar compartilham DER, ALR e lógica de processamento, e pelo critério de unicidade do CPM são o mesmo processo elementar.

A pergunta é de forma, não de mérito: para a rastreabilidade, preferem que a nossa documentação registre as duas features apontando para o mesmo PE (como está hoje), ou que unifiquemos em uma feature única "Decidir Inscrição"?

---

### Q12 — Duas linhas do baseline declaram ALR 1 e a memória nomeia dois arquivos lógicos

Ao tornar a memória de cálculo **conferível por máquina** — o gerador da planilha de entrega passou a comparar a quantidade declarada com o que a descrição enumera —, duas linhas do baseline não fecham:

| Processo elementar | Feature | ALR declarado | ALR que a memória nomeia |
|---|---|---|---|
| `Incluir Categoria` | `CFG-CAT-02` **Cadastrar Categoria** | 1 | 2 — Categoria · Premiação |
| `Editar Categoria` | `CFG-CAT-03` **Editar Categoria** | 1 | 2 — Categoria · Premiação |

**O número não muda**: pela Tabela 6 do CPM, uma EE com DER 4 fica em complexidade Baixa tanto com ALR 1 quanto com ALR 2 — os 3 PF de cada uma seguem válidos nas duas leituras. É inconsistência de documentação, não de dimensionamento.

**A pergunta**: qual das duas está certa — a quantidade ou a descrição? A resposta define o que o `global/CONTAGEM-PF.md` e os dois N3 devem registrar. Enquanto não vier, os dois ficam **como o baseline entregou**, com a divergência sinalizada aqui: corrigir a fonte da métrica por conta própria seria reescrever a medição de outra equipe.

---

### Q13 — O mesmo arquivo lógico aparece com dois nomes na memória

Ao consolidar as descrições de ALR numa coluna única da planilha de entrega, o ALI de tipo de participante sai com **duas grafias**:

| Grafia | Ocorrências | Origem |
|---|---|---|
| `Tipo Participante` | 36 | transcrição do baseline de 2026-02-28 |
| `Tipo de Participante` | 26 | `global/DATA-MODEL.md` e a contagem de 2026-09-01 |

São o mesmo arquivo lógico. Quem agrupar a coluna Descrição por nome — para conferir arquivo por arquivo, que é o uso da coluna — vai vê-lo partido em dois.

**A pergunta**: unificamos pela grafia do `DATA-MODEL.md` (`Tipo de Participante`), que é a fonte única de nomes de entidade nesta instância? Não mexi por conta própria porque as 36 ocorrências vêm da transcrição da medição de vocês — trocar nome em memória de cálculo alheia é o tipo de "correção" que reaparece como divergência na conferência seguinte.

**Não muda PF** em nenhuma hipótese: é grafia, não contagem.

> De passagem, duas grafias claramente erradas foram corrigidas na transcrição — `Iscrição` → `Inscrição` (2 ocorrências) e `Premiajção` → `Premiação` (1). São erros de digitação sem leitura alternativa possível, e a correção não toca nenhum número.

---

### Q14 — Quais campos compõem o DER de cada arquivo lógico?

O baseline traz a **quantidade** de DER por ALI, mas nunca a **lista**. Ao enumerar campo a campo o que o `global/data-models/` documenta, as duas populações não coincidem em nenhum dos doze:

| ALI | DER no baseline | Campos no data-model | Diferença |
|---|---|---|---|
| Premiação | 71 | 42 | −29 |
| Categoria | 13 | 5 | −8 |
| Modalidade | 19 | 8 | −11 |
| Tipo de Participante | 89 | 53 | −36 |
| Listas do Sistema | 14 | 6 | −8 |
| Inscrição | 85 | 61 | −24 |
| Notificação Participante | 13 | 7 | −6 |
| Validação Inscrição | 23 | 5 | −18 |
| Auditoria de E-mails | 20 | 18 | −2 |
| Avaliação de Inscrição | 38 | **45** | **+7** |
| Alocação Avaliadores | 12 | 6 | −6 |
| Usuário | 8 | 5 | −3 |

**Divergir é esperado, em parte.** O data-model documenta os atributos **físicos** levantados por engenharia reversa e omite, por convenção da instância, o identificador e os cinco campos globais de auditoria que toda entidade `Auditavel` herda — o que explica a maioria das diferenças para baixo. Em `Notificação Participante` e `Alocação Avaliadores` a conta fecha exatamente com `campos + 6`.

**Duas não se explicam por aí.** `Validação Inscrição` tem 5 campos documentados para 23 DER, e `Avaliação de Inscrição` tem **mais campos que DER** (45 contra 38) — o único caso em que o data-model enumera além do que o baseline contou.

**A pergunta**: vocês têm a lista dos DER que sustenta cada quantidade? Com ela, a planilha de entrega passa a trazer a enumeração real em vez do inventário de campos, e a conferência arquivo por arquivo fica possível. Enquanto não vier, a coluna sai rotulada como **Campos (data-model)**, justamente para não ser lida como a enumeração dos DER contados.

---

### Q15 — O RLR de seis arquivos lógicos não bate com as entidades que os compõem

A mesma enumeração que o Q14 fez para o DER, feita agora para o **RLR**, mostra que em **seis dos doze** arquivos lógicos o número do baseline não coincide com a quantidade de entidades constituintes que o `global/data-models/` documenta:

| ALI | RLR no baseline | Entidades constituintes | Diferença |
|---|---|---|---|
| Premiação | 9 | 8 | −1 |
| Tipo de Participante | 12 | 14 | +2 |
| Inscrição | 11 | 10 | −1 |
| Validação Inscrição | 3 | 1 | −2 |
| Avaliação de Inscrição | 3 | 7 | +4 |
| Usuário | 3 | 2 | −1 |

Nos outros seis a conta fecha. *(A tabela traz o RLR do **baseline**, como no Q14. Em `Avaliação de Inscrição` a SP05 levou o RLR de 3 para 4 — é esse 4 que a planilha de entrega mostra, por ser o tamanho DEPOIS que o CHGA usa; a distância para as 7 entidades cai de +4 para +3.)*

**Aqui a divergência incomoda mais do que no DER.** No Q14 as duas populações são reconhecidamente diferentes — atributo físico não é elemento reconhecido pelo usuário. No RLR não: o subgrupo lógico e a entidade constituinte descrevem a mesma coisa, e a lista deveria ser a memória do número. Sabemos que o CPM permite agrupar várias entidades físicas num mesmo RET — é a explicação natural para `Avaliação de Inscrição` (7 entidades reduzidas a 3 subgrupos) e `Tipo de Participante` —, mas ela não cobre os casos em que o baseline tem **mais** RLR do que entidades documentadas: `Premiação`, `Inscrição`, `Validação Inscrição` e `Usuário`. Aí falta entidade na nossa documentação, ou sobra RET na contagem.

**A pergunta**: qual o agrupamento de entidades em RET que sustenta cada número? Onde o baseline tem mais RLR do que documentamos, que subgrupo estamos deixando de descrever? `Validação Inscrição` é o caso mais gritante — 3 RET para 1 entidade documentada, e ela também é a de maior distância no DER (23 contra 5 campos), o que sugere que o problema ali é da nossa documentação, não da contagem.

**Uma ressalva sobre como contamos as entidades.** A coluna *Entidades constituintes* do `global/data-models/` separa itens por vírgula, mas usa `+` para **empacotar duas entidades num mesmo subgrupo** — é o caso de *Critério/Decisão de Desempate + Inscrição da Decisão* e de *Termo de Confidencialidade + Aceite*. A contagem acima é de **subgrupos como documentados**, que é o que se compara com RLR, não de tabelas físicas. Isso expõe uma incoerência nossa: para `Avaliação de Inscrição`, o índice `global/DATA-MODEL.md` anota *(+7)* — oito entidades — enquanto o fragmento documenta sete subgrupos. Vamos alinhar as duas pontas de qualquer forma; a pergunta abaixo continua de pé.

**Não arbitramos nada**: os números do consolidado continuam sendo os do baseline. A conferência sai na planilha de entrega, aba *Funções de Dados*, coluna **RLR / RET** — geração com `python3 scripts/gera-planilha-contagem.py . --jira --der-alr`, que também aponta as divergências na saída do terminal.

---

## Resumo das perguntas

| # | Bloco | Pergunta | PF envolvido |
|---|---|---|---|
| ~~Q1~~ | A | ✅ **Respondida** — a coluna PF Fábrica de Software tinha falha de preenchimento; vale o PF Bruto | — |
| ~~Q2~~ | A | ✅ **Respondida** — mesma causa da Q1 | — |
| ~~Q3~~ | A | ✅ **Respondida** — mesma causa da Q1 | — |
| Q4 | B | Fechamento da etapa (apurar, desempatar, encerrar, revisar) foi contado? | a apurar |
| Q5 | B | Onde está a transação de alteração da Premiação? | a apurar |
| Q6 | B | Confirmação de nove ausências menores | a apurar |
| Q7 | C | As cinco linhas com PF zero foram descartadas de propósito? | a apurar |
| Q8 | D | Três processos medidos sem feature — confirmam que estão em produção? | 15 |
| Q9 | D | A regra de contagem de combos permanece válida? | 28 |
| Q10 | D | Aceitar/Rejeitar: duas features para um PE — como registrar? | 6 |
| ~~Q11~~ | Anexo | ✅ **Respondida** — a tabela de fechamento é RLR de ALI existente, a coluna `CD_UUID` é funcional e não há outra tabela nova: valem os **40 PF** | 40 |

**Q1 a Q3 já foram respondidas** — a coluna PF Fábrica de Software tinha falha de preenchimento e foi descartada. A **Q11** também está respondida nos três itens: a tabela de fechamento é registro lógico de um ALI existente, a inclusão do `CD_UUID` é funcional e não há outra tabela nova — o lado de dados fecha em **40 PF de CHGA**. Restam sete perguntas: as de Q4 a Q7 alteram o nosso registro de rastreabilidade e as de Q8 a Q10 alteram apenas a forma de documentar.

---

---

## Anexo — Funções de dados a contar na evolução da SP05

> Confirmado pela equipe do projeto: **o baseline é anterior à SP05**. Logo os valores de DER e RLR registrados nele são o estado **antes** da sprint, e o modelo físico atual (`arquivos/modelo_dados.sql`) é o estado **depois**. Este anexo isola o delta no lado dos **dados** (ALI/AIE), para dimensionar a evolução sem recontar o que já estava no baseline.

### O que a SP05 mexeu no modelo

| Migração | Alteração física | ALI afetado |
|---|---|---|
| V00030 | `CD_UUID` em `TB_INSCRICAO_DOCUMENTO` | Inscrição |
| V00031 | `NR_CLASSIFICADOS` em `TB_ETAPA` | Premiação |
| V00032 | `NR_PREMIADOS` em `TB_ETAPA` | Premiação |
| V00032 | `FL_PREMIADO` em `TB_APROVACAO_ETAPA_PARTICIPANTE` | Avaliação de Inscrição |
| V00032 | `DS_TIPO_CORTE` em `TB_DESEMPATE_DECISAO` | Avaliação de Inscrição |
| V00033 | tabela nova `TB_FECHAMENTO_ETAPA_UF` | Avaliação de Inscrição |

### Antes e depois, por ALI

Os DER contam cada atributo uma única vez dentro do ALI: dos seis campos de `TB_FECHAMENTO_ETAPA_UF`, quatro (`CD_ETAPA`, `CD_USUARIO_RESPONSAVEL`, `NM_USUARIO_RESPONSAVEL`, `DS_OBSERVACAO`) já existiam no grupo, então só `CD_UF` e `DT_FECHAMENTO` acrescentam DER.

| ALI | RLR/DER antes | RLR/DER depois | Complexidade antes | Complexidade depois | Conta como |
|---|---|---|---|---|---|
| Premiação | 9 / 71 | 9 / 73 | Alta | Alta | **CHGA — 15 PF** |
| Inscrição | 11 / 85 | 11 / 86 | Alta | Alta | **CHGA — 15 PF** |
| Avaliação de Inscrição | 3 / 38 | 4 / 42 | Média | Média | **CHGA — 10 PF** |
| Alocação Avaliadores | 1 / 12 | 1 / 12 | Baixa | Baixa | não muda |
| Demais 8 ALIs | — | — | — | — | não mudam |
| AIE | — | — | — | — | nenhum (o baseline não tem AIE) |

**Total das funções de dados na evolução: 40 PF de CHGA · nenhum ADD · nenhum DEL.**

### Três pontos que decidem esse número

**1. A tabela nova não vira ALI novo.** `TB_FECHAMENTO_ETAPA_UF` é entidade dependente — só existe vinculada a uma Etapa, e excluir a etapa elimina seus registros. Pela regra de agrupamento do CPM ela entra como **mais um RLR dentro de um ALI existente**, não como função de dados própria. Contá-la como ALI novo acrescentaria 7 a 10 PF indevidos.

**2. Nenhum ALI muda de faixa de complexidade.** Premiação e Inscrição já estavam em Alta (o teto), e Avaliação de Inscrição sai de 3 RLR × 38 DER para 4 RLR × 42 DER, permanecendo em Média pela Tabela 1 do CPM. Como o CHGA é dimensionado pelo tamanho **depois** da alteração, os 40 PF são iguais ao que essas três funções já valiam — a evolução altera o conteúdo, não o tamanho.

> Margem de segurança: Avaliação de Inscrição sobe para Alta se ganhar mais 2 RLR (passando de 5) ou mais 9 DER (passando de 50). Vale reavaliar na próxima evolução do fechamento.

**3. O resultado é robusto à dúvida de agrupamento.** Há uma decisão em aberto sobre a qual ALI o fechamento pertence: por dependência ele segue a Etapa (ALI Premiação); por função, é o desfecho da avaliação (ALI Avaliação de Inscrição). Testamos as duas alocações e **nenhuma altera a complexidade** de qualquer dos dois ALIs — o total de 40 PF se mantém nas duas leituras. A escolha é de rastreabilidade, não de tamanho.

### Q11 — Como contar as funções de dados da SP05? ✅ RESPONDIDA

Pedimos a confirmação de três decisões, que fecham o dimensionamento do lado de dados:

- **(a)** ✅ **Confirmado (2026-08-28)**: `TB_FECHAMENTO_ETAPA_UF` **faz parte de um ALI existente** — entra como registro lógico do ALI *Avaliação de Inscrição*, não como função de dados nova. Os três ALIs alterados entram como **CHGA de 40 PF**.
- **(b)** ✅ **Confirmado (2026-08-28)**: a inclusão da coluna `CD_UUID` é **funcional** — necessidade de negócio, não motivação puramente técnica. O ALI Inscrição permanece na conta; o total do lado de dados fica nos **40 PF**, e não nos 25 PF da hipótese alternativa.
- **(c)** ✅ **Confirmado (2026-08-28)**: `TB_FECHAMENTO_ETAPA_UF` é a **única tabela incluída** na sprint. A lista das seis alterações de modelo está completa, ainda que não tenhamos tido acesso ao modelo físico anterior nem aos arquivos de migração.

> **Efeito colateral sobre a Q4.** Com o baseline sendo anterior à SP05, a ausência das transações de fechamento na planilha deixa de ser lacuna: elas **não existiam** quando a contagem foi feita. Isso reposiciona `AVL-APU-01`, `AVL-APU-02`, `AVL-APU-03` e `AVL-APU-05`, junto com as features novas de HU-036 e HU-038, como **ADD na contagem da SP05** — e não como algo a corrigir no baseline. A pergunta que resta na Q4 é apenas se já foram contadas em outro artefato da própria sprint.

---

## Como reproduzir a conciliação

A conciliação completa, com a correspondência de cada um dos 139 processos elementares, está em `global/SIZING.md` → seção *Conciliação Feature ↔ Processo Elementar (baseline APF)*. A tabela de rastreabilidade em `modules/INDEX.md` traz, para cada uma das 110 features, o nome do processo elementar como consta na planilha.

Os números deste documento saem da aba *AFP - Detalhada*: coluna **Processos elementares** para o nome, **Tipo** para a classificação, **PFB** para o PF bruto, **PFL** para o PF Fábrica de Software e **Insumo** para o agrupamento das deduções.

---

## Changelog

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-02 | Contagem APF (docqui) | Q15 aberta · Q7 respondida em parte | Q15 registra que o RLR de seis arquivos lógicos não bate com as entidades constituintes documentadas — achado da enumeração campo a campo pedida para a entrega da SP05. Q7 passa a ⏳ com o critério de fronteira |
| 2026-09-01 | Contagem APF (docqui) | Q14 acrescentada | O baseline traz a quantidade de DER por ALI, nunca a lista. A enumeração dos campos do data-model não coincide em nenhum dos doze; duas divergências não se explicam pelos campos globais omitidos |
| 2026-09-01 | Contagem APF (docqui) | Q13 acrescentada | O ALI de tipo de participante aparece com duas grafias na memória — 36 do baseline, 26 do DATA-MODEL. Achado ao consolidar a coluna Descrição de ALR na planilha. Não muda PF |
| 2026-09-01 | Contagem APF (docqui) | Q12 acrescentada | Duas linhas do baseline declaram ALR 1 e nomeiam dois arquivos lógicos na memória. Achado pelo gerador da planilha de entrega, que passou a conferir quantidade contra descrição. Não muda PF |
| 2026-08-27 | Equipe de especificação (docqui) | Documento criado | Dez questionamentos derivados da conciliação entre as 110 features e os 139 processos elementares do baseline |
