<!-- docqui: 4.1.0 | prompt: PROMPT_REVERSE_ENGINEERING | atualizado: 2026-10-04 -->
# Data Model: Configuração da Premiação
> Fragmento do DATA-MODEL.md — cole apenas este arquivo nas sessões que envolvam o domínio Configuração da Premiação.
>
> **ALIs deste domínio**: Premiação · Categoria · Modalidade · Tipo de Participante · Listas do Sistema
> ✅ **Label Dev conciliado com o código** (2026-08-28): cada Label Dev abaixo é o nome do atributo Java da entidade JPA correspondente em `br.com.cni.apipremioieltalentos.domain`. Onde o atributo é uma associação (`@ManyToOne`), o Label Dev é o nome da referência (ex.: `premiacao`), não `premiacaoId`. O **campo banco** é o `@Column(name=…)` transcrito exatamente.

---

## Premiação
> **ALI: Premiação** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome da premiação | nome | NM_PREMIACAO | nvarchar(200) | sim | |
| Descrição | descricao | DS_PREMIACAO | nvarchar(MAX) | não | Texto longo |
| Data de início | dataInicio | DT_INICIO | date | sim | |
| Data de término | dataFim | DT_FIM | date | sim | |
| Imagem do banner | imagemBanner | DS_IMAGEM_BANNER | nvarchar(500) | não | URL/caminho da imagem ⚠️ |
| URL do regulamento | regulamentoUrl | DS_REGULAMENTO_URL | nvarchar(500) | não | → ver FIELD-DICTIONARY: URL |
| Avaliação confidencial para o avaliador | confidencialAvaliador | FL_CONFIDENCIAL_AVALIADOR | bit | automático | default 0 (não); avaliação às cegas ⚠️ |
| Mostrar nota da etapa anterior | mostrarNotaEtapaAnterior | FL_MOSTRAR_NOTA_ETAPA_ANTERIOR | bit | automático | default 0 (não) |
| Avaliadores por inscrição | qtdAvaliadoresPorInscricao | QT_AVALIADORES_POR_INSCRICAO | int | não | Nº de avaliadores designados por inscrição |
| Fator de pontuação | fatorPontuacao | VL_FATOR_PONTUACAO | decimal(5,2) | automático | default 20,00; fator de cálculo da nota final ⚠️ |

---

## Branding da Premiação
> **ALI: Premiação** · entidade de suporte (identidade visual)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| URL do logotipo | logoUrl | DS_LOGO_URL | nvarchar(500) | não | → ver FIELD-DICTIONARY: URL |
| Cor primária | corPrimaria | DS_COR_PRIMARIA | nvarchar(20) | não | Código de cor (ex.: hex) ⚠️ |
| Cor secundária | corSecundaria | DS_COR_SECUNDARIA | nvarchar(20) | não | Código de cor (ex.: hex) ⚠️ |
| Cor de fundo | corFundo | DS_COR_FUNDO | nvarchar(20) | não | Código de cor (ex.: hex) ⚠️ |
| URL do banner | bannerUrl | DS_BANNER_URL | nvarchar(500) | não | → ver FIELD-DICTIONARY: URL |
| URL do favicon | faviconUrl | DS_FAVICON_URL | nvarchar(500) | não | → ver FIELD-DICTIONARY: URL |

---

## Configuração de E-mail da Premiação
> **ALI: Premiação** · entidade de suporte (modelos de e-mail transacional)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Tipo de e-mail | tipoEmail | DS_TIPO_EMAIL | nvarchar(50) | sim | enum `TipoEmailEnum`: AJUSTE_SOLICITADO · INSCRICAO_APROVADA · INSCRICAO_REJEITADA · DEVOLUCAO_ADMIN · NOVA_ALOCACAO_AVALIADOR · ETAPA_FECHADA_PARA_AVALIADOR · TODOS_AVALIADORES_FINALIZARAM_PARA_ADMIN · **FEEDBACK_ETAPA_DISPONIVEL** (V00034) ⚠️ não confundir `DEVOLUCAO_ADMIN` — devolução **ao administrador** — com o feedback ao participante |
| Assunto | assunto | DS_ASSUNTO | nvarchar(500) | sim | |
| Corpo do e-mail (HTML) | corpoHtml | DS_CORPO_HTML | nvarchar(MAX) | não | Texto longo (HTML) |

A **V00034** insere o modelo `FEEDBACK_ETAPA_DISPONIVEL` em cada premiação ativa que ainda não o tenha; premiação criada depois já nasce com ele. Acrescentar valor ao enum **não cria DER**: o atributo `DS_TIPO_EMAIL` já existia e já era referenciado, de modo que o ALI **Premiação** permanece com 9 RLR, 71 DER e 15 PF.

---

## Termo de Aceite
> **ALI: Premiação** · entidade de suporte (termos que o participante aceita)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Título | titulo | NM_TITULO | nvarchar(500) | sim | |
| Texto do termo (HTML) | textoHtml | DS_TEXTO_HTML | nvarchar(MAX) | não | Texto longo (HTML) |
| Versão | versao | NR_VERSAO | int | automático | default 1 |
| Obrigatório | obrigatorio | FL_OBRIGATORIO | bit | automático | default 1 (sim) |

---

## Link Público
> **ALI: Premiação** · entidade de suporte (links públicos de inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | não | FK → TB_TIPO_PARTICIPANTE |
| Oferta (tipo×modalidade×categoria) | tipoParticipanteModCat | CD_TIPO_PART_MOD_CAT | int | não | FK → TB_TIPO_PART_MOD_CAT |
| Token do link | tokenUnico | DS_TOKEN_UNICO | nvarchar(255) | sim | único (UQ_LINK_TOKEN) ⚠️ |
| Slug da URL | urlSlug | DS_URL_SLUG | nvarchar(255) | não | Compõe a URL pública ⚠️ |
| Data de criação do link | dataCriacao | DT_CRIACAO | datetime2(7) | automático | default `getdate()`; timestamp de negócio, distinto do técnico DT_CRIADO_EM ⚠️ |
| Data de expiração | dataExpiracao | DT_EXPIRACAO | datetime2(7) | não | |

---

## Etapa
> **ALI: Premiação** · entidade de suporte (etapas/fases da premiação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Nome da etapa | nome | NM_ETAPA | nvarchar(200) | sim | |
| Ordem | ordem | NR_ORDEM | int | sim | único por (premiação, ordem) — UQ_ETAPA_PREMIACAO_ORDEM_ATIVO |
| Data de início | dataInicio | DT_INICIO | date | sim | |
| Data de término | dataFim | DT_FIM | date | sim | |
| Situação | situacao | DS_SITUACAO | varchar(30) | automático | enum `SituacaoEtapaEnum`: ABERTA (default) · FECHADA |
| Data de liberação do feedback | dataLiberacaoFeedback | DT_LIBERACAO_FEEDBACK | date | não | |
| Nº de classificados | quantidadeClassificados | NR_CLASSIFICADOS | int | automático | default 1 |
| Nº de premiados | quantidadePremiados | NR_PREMIADOS | int | não | |

---

## Perfil de Acesso à Etapa
> **ALI: Premiação** · entidade de suporte (perfis com acesso à etapa)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Etapa | etapa | CD_ETAPA | int | sim | FK → TB_ETAPA |
| Perfil | perfilId | CD_PERFIL | varchar(10) | sim | código de perfil do portal corporativo; restrito por `CK_ETAPA_PERFIL_VALIDO` a **PIT.1** (Administrador Nacional) e **PIT.3** (Administrador Regional); único por (etapa, perfil) — UQ_ETAPA_PERFIL |

---

## Critério de Avaliação
> **ALI: Premiação** · entidade de suporte (critérios de avaliação — ⚠️ configurados aqui, consumidos no módulo Avaliação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO |
| Categoria | categoria | CD_CATEGORIA | int | não | FK → TB_CATEGORIA |
| Nome do critério | nome | NM_CRITERIO_AVALIACAO | nvarchar(300) | sim | |
| Descrição do critério | descricao | DS_CRITERIO_AVALIACAO | nvarchar(MAX) | não | Texto longo |
| Peso | peso | NR_PESO | decimal(5,2) | automático | default 1,00 |
| Ordem | ordem | NR_ORDEM | int | automático | default 0 |

---

## Categoria
> **ALI: Categoria** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome da categoria | nome | NM_CATEGORIA | nvarchar(200) | sim | |
| Descrição | descricao | DS_CATEGORIA | nvarchar(MAX) | não | Texto longo |

---

## Premiação × Categoria (vínculo)
> **ALI: Categoria** · entidade de suporte (vínculo Premiação↔Categoria por edição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Premiação | premiacao | CD_PREMIACAO | int | sim | FK → TB_PREMIACAO; único por (premiação, categoria) — UQ_PREM_CAT |
| Categoria | categoria | CD_CATEGORIA | int | sim | FK → TB_CATEGORIA |
| Ordem de exibição | ordem | NR_ORDEM | int | automático | default 0 |

---

## Modalidade
> **ALI: Modalidade** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome da modalidade | nome | NM_MODALIDADE | nvarchar(200) | sim | |
| Descrição | descricao | DS_MODALIDADE | nvarchar(MAX) | não | Texto longo |

---

## Modalidade × Categoria (vínculo)
> **ALI: Modalidade** · entidade de suporte (vínculo Modalidade↔Categoria-da-premiação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Modalidade | modalidade | CD_MODALIDADE | int | sim | FK → TB_MODALIDADE; único por (modalidade, categoria da premiação) — UQ_MOD_CAT |
| Categoria da premiação | premiacaoCategoria | CD_PREMIACAO_CATEGORIA | int | sim | FK → TB_PREMIACAO_CATEGORIA |
| Link do regulamento | regulamentoLink | DS_REGULAMENTO_LINK | nvarchar(500) | não | → ver FIELD-DICTIONARY: URL ⚠️ (coluna _LINK) |
| Início das inscrições | inscricaoInicio | DT_INSCRICAO_INICIO | datetime2(7) | não | |
| Fim das inscrições | inscricaoFim | DT_INSCRICAO_FIM | datetime2(7) | não | |
| Ordem | ordem | NR_ORDEM | int | automático | default 0 |

---

## Tipo de Participante
> **ALI: Tipo de Participante** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Nome do tipo de participante | nome | NM_TIPO_PARTICIPANTE | nvarchar(200) | sim | |
| Descrição | descricao | DS_TIPO_PARTICIPANTE | nvarchar(MAX) | não | Texto longo |
| Abrangência | abrangencia | DS_ABRANGENCIA | varchar(10) | automático | enum textual (`CHECK` da V00006): NACIONAL (default) · REGIONAL |

---

## Oferta (Tipo × Modalidade × Categoria)
> **ALI: Tipo de Participante** · entidade de suporte (oferta: tipo×modalidade×categoria — permite equipe, min/max, slug)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE; único por (tipo de participante, modalidade-categoria) — UQ_TPMC |
| Modalidade da categoria | modalidadeCategoria | CD_MODALIDADE_CATEGORIA | int | sim | FK → TB_MODALIDADE_CATEGORIA |
| Permite equipe | permiteEquipe | FL_PERMITE_EQUIPE | bit | automático | default 0 (não) |
| Mínimo de membros da equipe | equipeMinimo | QT_EQUIPE_MINIMO | int | não | |
| Máximo de membros da equipe | equipeMaximo | QT_EQUIPE_MAXIMO | int | não | |
| Slug da URL | slugUrl | DS_SLUG_URL | nvarchar(200) | não | → ver FIELD-DICTIONARY: URL ⚠️ (slug de URL pública) |
| Ordem | ordem | NR_ORDEM | int | automático | default 0 |

---

## Formulário Dinâmico
> **ALI: Tipo de Participante** · entidade de suporte (formulário de inscrição)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE; único (1 formulário por tipo de participante) — UQ_FORMULARIO_TIPO_PART |
| Nome do formulário | nome | NM_FORMULARIO_DINAMICO | nvarchar(200) | não | |
| Título | titulo | DS_TITULO | nvarchar(300) | não | |
| Descrição do formulário | descricao | DS_FORMULARIO_DINAMICO | nvarchar(MAX) | não | Texto longo |
| Versão | versao | NR_VERSAO | int | automático | default 1 |
| Configuração (JSON) | configuracaoJson | DS_CONFIGURACAO_JSON | nvarchar(MAX) | não | Estrutura JSON ⚠️ |

---

## Seção do Formulário
> **ALI: Tipo de Participante** · entidade de suporte (seções do formulário)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Formulário | formularioDinamico | CD_FORMULARIO_DINAMICO | int | sim | FK → TB_FORMULARIO_DINAMICO |
| Nome da seção | nome | NM_SECAO_FORMULARIO | nvarchar(300) | sim | |
| Descrição da seção | descricao | DS_SECAO_FORMULARIO | nvarchar(MAX) | não | Texto longo |
| Ordem | ordem | NR_ORDEM | int | automático | default 0 |
| Obrigatória | obrigatoria | FL_OBRIGATORIA | bit | automático | default 1 (sim) |

---

## Campo do Formulário
> **ALI: Tipo de Participante** · entidade de suporte (campos do formulário dinâmico)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Formulário | formularioDinamico | CD_FORMULARIO_DINAMICO | int | sim | FK → TB_FORMULARIO_DINAMICO |
| Tipo de campo | tipoCampo | CD_TIPO_CAMPO | int | sim | FK → TB_TIPO_CAMPO |
| Seção | secaoFormulario | CD_SECAO_FORMULARIO | int | não | FK → TB_SECAO_FORMULARIO |
| Rótulo | rotulo | NM_ROTULO | nvarchar(300) | sim | |
| Descrição do campo | descricao | DS_FORMULARIO_CAMPO | nvarchar(500) | não | |
| Placeholder | placeholder | DS_PLACEHOLDER | nvarchar(500) | não | Texto-guia exibido no campo vazio ⚠️ |
| Dica de preenchimento | dicaPreenchimento | DS_DICA_PREENCHIMENTO | nvarchar(1000) | não | |
| Regex de validação | validacaoRegex | DS_VALIDACAO_REGEX | nvarchar(500) | não | Expressão regular de validação ⚠️ |
| Opções (JSON) | opcoesJson | DS_OPCOES_JSON | nvarchar(MAX) | não | Estrutura JSON ⚠️ |
| Configuração (JSON) | configuracaoJson | DS_CONFIGURACAO_JSON | nvarchar(MAX) | não | Estrutura JSON ⚠️ |
| Personalização (JSON) | personalizacaoJson | DS_PERSONALIZACAO_JSON | nvarchar(MAX) | não | Estrutura JSON ⚠️ |
| Obrigatório | obrigatorio | FL_OBRIGATORIO | bit | automático | default 0 (não) |
| Colunas no grid | colunaGrid | NR_COLUNA_GRID | int | automático | default 12; largura no layout em grade ⚠️ |
| Ordem | ordem | NR_ORDEM | int | sim | |
| Tamanho máximo | tamanhoMaximo | NR_TAMANHO_MAXIMO | int | não | |
| Etapa (identificador) | etapaId | ID_ETAPA | nvarchar(36) | não | Código textual (aparência de GUID); sem FK declarada no schema ⚠️ |
| Campo identificador | isIdentificador | FL_IDENTIFICADOR | bit | automático | default 0; provável único filtrado por formulário (UQ_FORM_CAMPO_IDENTIFICADOR) ⚠️ |

---

## Tipo de Campo (referência)
> **ALI: Tipo de Participante** · entidade de suporte (referência: tipos de campo)

Tabela de referência: catálogo de tipos de campo do formulário. Não possui os 6 campos globais padrão (criado/atualizado por/em, ativo).

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Código do tipo | codigo | ID_CODIGO | varchar(50) | sim | Código textual; único (UQ_TIPO_CAMPO_CODIGO) |
| Nome do tipo de campo | nome | NM_TIPO_CAMPO | nvarchar(100) | sim | |
| Ícone | icone | DS_ICONE | nvarchar(100) | não | Identificador/nome do ícone ⚠️ |

---

## Configuração de Anexo
> **ALI: Tipo de Participante** · entidade de suporte (config de anexos exigidos)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE |
| Nome do anexo | nome | NM_ANEXO_CONFIGURACAO | nvarchar(300) | sim | |
| Descrição do anexo | descricao | DS_ANEXO_CONFIGURACAO | nvarchar(MAX) | não | Texto longo |
| Obrigatório | obrigatorio | FL_OBRIGATORIO | bit | automático | default 0 (não) |
| Extensões permitidas | extensaoPermitida | DS_EXTENSAO_PERMITIDA | nvarchar(200) | sim | Lista de extensões aceitas ⚠️ |
| Tamanho máximo (MB) | tamanhoMaximoMB | NR_TAMANHO_MAXIMO_MB | int | automático | default 10 |
| Ordem | ordem | NR_ORDEM | int | não | |

---

## Enquadramento
> **ALI: Tipo de Participante** · entidade de suporte (enquadramentos)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE |
| Nome do enquadramento | nome | NM_ENQUADRAMENTO | nvarchar(200) | sim | |
| Descrição | descricao | DS_DESCRICAO | nvarchar(MAX) | não | Texto longo |

---

## Configuração de Membro de Equipe
> **ALI: Tipo de Participante** · entidade de suporte (config de campos extras de membro de equipe)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE |
| Nome do campo extra | campoExtra | NM_CAMPO_EXTRA | nvarchar(200) | não | Campo adicional a coletar por membro ⚠️ |
| Obrigatório | obrigatorio | FL_OBRIGATORIO | bit | automático | default 0 (não) |

---

## Tipo de Vínculo de Membro
> **ALI: Tipo de Participante** · entidade de suporte (tipos de vínculo de membro)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE |
| Nome do tipo de vínculo | nome | NM_TIPO_VINCULO_MEMBRO | nvarchar(200) | sim | |
| Ordem | ordem | NR_ORDEM | int | não | |

---

## Questionário
> **ALI: Tipo de Participante** · entidade de suporte (questionário de avaliação)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Tipo de participante | tipoParticipante | CD_TIPO_PARTICIPANTE | int | sim | FK → TB_TIPO_PARTICIPANTE; único (1 por tipo de participante) — UQ_QUESTIONARIO_TIPO_PART |
| Nome do questionário | nome | NM_QUESTIONARIO | nvarchar(200) | não | |
| Descrição do questionário | descricao | DS_QUESTIONARIO | nvarchar(MAX) | não | Texto longo |

---

## Questão de Avaliação
> **ALI: Tipo de Participante** · entidade de suporte (questões do questionário)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Questionário | questionario | CD_QUESTIONARIO | int | sim | FK → TB_QUESTIONARIO |
| Tipo de questão | tipoQuestao | CD_TIPO_QUESTAO | int | sim | FK → TB_TIPO_QUESTAO |
| Enunciado | enunciado | DS_ENUNCIADO | nvarchar(MAX) | sim | Texto longo |
| Limite de caracteres | limiteCaracteres | NR_LIMITE_CARACTERES | int | não | |
| Ordem | ordem | NR_ORDEM | int | sim | |
| Obrigatório | obrigatorio | FL_OBRIGATORIO | bit | automático | default 1 (sim) |
| Peso da nota | pesoNota | VL_PESO_NOTA | decimal(5,2) | automático | default 1,00 |
| Título | titulo | DS_TITULO | nvarchar(500) | não | |
| Descrição | descricao | DS_DESCRICAO | nvarchar(MAX) | não | Texto longo |

---

## Alternativa da Questão
> **ALI: Tipo de Participante** · entidade de suporte (alternativas da questão)

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Questão | questaoAvaliacao | CD_QUESTAO_AVALIACAO | int | sim | FK → TB_QUESTAO_AVALIACAO |
| Texto da alternativa | texto | DS_TEXTO | nvarchar(500) | sim | |
| Ordem | ordem | NR_ORDEM | int | não | |

---

## Tipo de Questão (referência)
> **ALI: Tipo de Participante** · entidade de suporte (referência: tipos de questão)

Tabela de referência: catálogo de tipos de questão. Não possui os 6 campos globais padrão (criado/atualizado por/em, ativo).

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Código do tipo | codigo | ID_CODIGO | varchar(50) | sim | Código textual; único (UQ_TIPO_QUESTAO_CODIGO) |
| Nome do tipo de questão | nome | NM_TIPO_QUESTAO | nvarchar(100) | sim | |

---

## Lista do Sistema
> **ALI: Listas do Sistema** · entidade principal

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Código da lista | codigo | ID_CODIGO | varchar(50) | sim | Código textual; único (UQ_LISTA_SISTEMA_CODIGO) |
| Nome da lista | nome | NM_LISTA_SISTEMA | nvarchar(200) | sim | |

---

## Item da Lista do Sistema
> **ALI: Listas do Sistema** · entidade de suporte (itens da lista)

Guarda apenas o flag global `FL_ATIVO` (soft delete); não tem os demais campos globais de auditoria (criado/atualizado por/em).

| Label PO | Label Dev | Campo banco | Tipo SQL | Obrigatório | Notas |
|---|---|---|---|---|---|
| Lista | listaSistema | CD_LISTA_SISTEMA | int | sim | FK → TB_LISTA_SISTEMA |
| Valor do item | valor | VL_ITEM | nvarchar(200) | sim | Valor armazenado do item ⚠️ |
| Texto exibido | texto | DS_TEXTO | nvarchar(300) | sim | Rótulo apresentado ao usuário |
| Ordem | ordem | NR_ORDEM | int | não | |

---

## Arquivos Lógicos deste domínio

> Contagem do baseline APF do sistema (PIEL_BASELINE_PF_CD — elaborador: equipe de métricas). RLR/DER conforme o baseline; o agrupamento físico é o mapeamento reverso.

| ALI / AIE | Tipo | Entidades constituintes | RLR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Premiação | ALI | Premiação (principal) · Branding, Configuração de E-mail, Termo de Aceite, Link Público, Etapa, Perfil de Acesso à Etapa, Critério de Avaliação (subgrupos) | 9 | 71 | Alta | 7,5 | 2026-02-28 |
| Categoria | ALI | Categoria (principal) · Premiação × Categoria (subgrupo) | 2 | 13 | Baixa | 7 | 2026-02-28 |
| Modalidade | ALI | Modalidade (principal) · Modalidade × Categoria (subgrupo) | 2 | 19 | Baixa | 7 | 2026-02-28 |
| Tipo de Participante | ALI | Tipo de Participante (principal) · Oferta (TPMC), Formulário Dinâmico, Seção, Campo, Tipo de Campo, Configuração de Anexo, Enquadramento, Config. de Membro de Equipe, Tipo de Vínculo de Membro, Questionário, Questão, Alternativa, Tipo de Questão (subgrupos) | 12 | 89 | Alta | 15 | 2026-02-28 |
| Listas do Sistema | ALI | Lista do Sistema (principal) · Item da Lista do Sistema (subgrupo) | 2 | 14 | Baixa | 7 | 2026-02-28 |

**Total deste domínio: 43,5 PF**

<details><summary>Memória de cálculo</summary>

**ALI: Premiação** — RLR 9 · DER 71 · Alta · 15 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_PREMIACAO (principal), TB_BRANDING_PREMIO (branding), TB_CONFIGURACAO_EMAIL_PREMIO (config e-mail), TB_TERMO_ACEITE (termos), TB_LINK_PUBLICO (links públicos), TB_ETAPA (etapas), TB_ETAPA_PERFIL_ACESSO (perfis de acesso à etapa), TB_CRITERIO_AVALIACAO (critérios de avaliação).
- Os 15 PF são o **PF Bruto (PFB)** do baseline, coerentes com a Tabela 1 do CPM para RLR 9 × DER 71 (Alta). A coluna *PF Fábrica de Software* trazia 7,5 (dedução de 50% pelo insumo 47) — coluna descartada pela equipe de métricas como falha de preenchimento (Q3 do questionamento, respondida em 2026-08-28).
- ⚠️ 8 tabelas físicas neste domínio vs. RLR 9 do baseline — a granularidade de RET do mapeamento físico difere do baseline.
- ⚠️ TB_CRITERIO_AVALIACAO é configurado aqui, mas consumido pelo módulo Avaliação (notas por critério).

**ALI: Categoria** — RLR 2 · DER 13 · Baixa · 7 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_CATEGORIA (principal), TB_PREMIACAO_CATEGORIA (suporte: vínculo Premiação↔Categoria).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**ALI: Modalidade** — RLR 2 · DER 19 · Baixa · 7 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_MODALIDADE (principal), TB_MODALIDADE_CATEGORIA (suporte: vínculo Modalidade↔Categoria-da-premiação).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**ALI: Tipo de Participante** — RLR 12 · DER 89 · Alta · 15 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_TIPO_PARTICIPANTE (principal), TB_TIPO_PART_MOD_CAT (oferta tipo×modalidade×categoria), TB_FORMULARIO_DINAMICO (formulário), TB_SECAO_FORMULARIO (seções), TB_FORMULARIO_CAMPO (campos), TB_TIPO_CAMPO (referência: tipos de campo), TB_ANEXO_CONFIGURACAO (anexos exigidos), TB_ENQUADRAMENTO (enquadramentos), TB_MEMBRO_EQUIPE_CONFIG (campos extras de membro), TB_TIPO_VINCULO_MEMBRO (tipos de vínculo), TB_QUESTIONARIO (questionário), TB_QUESTAO_AVALIACAO (questões), TB_QUESTAO_ALTERNATIVA (alternativas), TB_TIPO_QUESTAO (referência: tipos de questão).
- ⚠️ 14 tabelas físicas neste domínio vs. RLR 12 do baseline — a granularidade de RET do mapeamento físico difere do baseline.
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

**ALI: Listas do Sistema** — RLR 2 · DER 14 · Baixa · 7 PF (baseline APF)
- Constituintes físicos (engenharia reversa): TB_LISTA_SISTEMA (principal), TB_LISTA_SISTEMA_ITEM (suporte: itens da lista).
- ⚠️ RLR/DER são do baseline APF (autoritativo); a granularidade de RET do mapeamento físico pode diferir.

</details>
