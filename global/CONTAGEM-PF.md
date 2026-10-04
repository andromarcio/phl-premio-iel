<!-- docqui: 2.23.0 | prompt: PROMPT_CONTAGEM | atualizado: 2026-10-04 -->
# CONTAGEM-PF.md
> **Registro consolidado da contagem de Pontos de Função (APF / IFPUG CPM 4.3.1)** do sistema Prêmio IEL de Talentos. Reúne todos os **Processos Elementares (PE)** — as Funções de Transação EE/SE/CE — e todas as **Funções de Dados (ALI/AIE)**.
>
> **Fonte**: baseline APF `arquivos/PIEL_BASELINE_PF_CD.xlsx` (aba *AFP - Detalhada*, coluna **PFB**), elaborado pela equipe de métricas em 2026-02-28. A memória de cálculo — ALR e DER nomeados — vem da própria planilha; nenhum número aqui foi arbitrado.
>
> **Espelhos**: cada PE também vive na seção `## Métricas de tamanho` do seu N3; as funções de dados espelham `global/DATA-MODEL.md → ## ALIs`. Critérios em `global/SIZING.md`; conciliação PE ↔ feature em `global/SIZING.md → Conciliação Feature ↔ Processo Elementar`.
>
> ⚠️ **A coluna `PFL` da planilha não é usada** — a equipe de métricas confirmou em 2026-08-28 que estava com falha de preenchimento. Vale o **PFB**. Não confundir com o *PFL da evolução* (100% incluída / 50% alterada), que é conceito de projeto de melhoria e vive nas análises de impacto, não aqui.

> ⚠️ **Duas convenções locais de contagem em vigor** — ver `global/SIZING.md`, regra 9 e *O que contar e o que não contar no N3*. **1)** Cada formato de exportação construído é um processo elementar próprio, nomeado `Consultar <Coisa> (<Formato>)` — ex.: `Consultar Clientes (PDF)`. **2)** Cada combo que carrega opções de um ALI ou AIE é um processo elementar, nomeado `Consultar <Entidade> (combo)`. A primeira **diverge do CPM** (que não adota *Multiple Media*): declare a divergência ao entregar a contagem a auditoria externa ou a medição contratual. Linhas vindas de baseline externo mantêm o nome da planilha de origem.

---

## ⚙️ Regra de manutenção

Sempre que um N3 for criado ou alterado, ou uma entidade (ALI/AIE) mudar, **reconte na fonte** e propague: a linha do PE aqui, a `## Métricas de tamanho` do N3, o total do `modules/INDEX.md` e o `## Changelog` do artefato. Mudança **puramente técnica**, que não altera a lógica de processamento sob a ótica do usuário, não gera nova contagem — ver `SIZING.md → Regras de medição de serviços, item 5`.

> **Regra de ouro: as fontes mandam; este arquivo as espelha.** Nunca registre aqui um número que não exista na fonte.

---

## 1. Funções de Transação — Processos Elementares (PE)

Os **139 processos elementares** medidos no baseline. A coluna **Feature (N3)** traz a feature que absorve o PE — `—` quando o PE não tem feature correspondente (combo de apoio ou lacuna da spec, ver `SIZING.md`).

A coluna **Observação** guarda o que é do **processo elementar**, não de uma contagem específica: por que uma linha ficou sem PF, que convenção a equipe de métricas aplicou ali, que armadilha de leitura ela esconde. É o lugar de registrar o critério **uma vez**, para que a próxima recontagem não precise redescobri-lo — e para que uma linha zerada não se confunda com linha por preencher.

| # | Processo elementar | Feature (N3) | Domínio | Tipo | ALR | DER | Complexidade | PF | Observação |
|---|---|---|---|---|---|---|---|---|---|
| 1 | Pesquisar Usuários | [`ACS-ADM-01` Pesquisar Administradores](../modules/acesso/administradores-regionais/f-pesquisar-administrador.md) | Acesso e Gestão | CE | 1 | 10 | Simples | 3 | — |
| 2 | Incluir Usuário | [`ACS-ADM-02` Cadastrar Administrador Regional](../modules/acesso/administradores-regionais/f-cadastrar-administrador-regional.md) | Acesso e Gestão | EE | 1 | 12 | Simples | 3 | — |
| 3 | Consultar Usuário (implícito) | [`ACS-ADM-03` Editar Administrador Regional](../modules/acesso/administradores-regionais/f-editar-administrador-regional.md) | Acesso e Gestão | EE | 1 | 11 | Simples | 3 | — |
| 4 | Editar Usuário | [`ACS-ADM-03` Editar Administrador Regional](../modules/acesso/administradores-regionais/f-editar-administrador-regional.md) | Acesso e Gestão | EE | 1 | 11 | Simples | 3 | — |
| 5 | Pesquisar Categorias | [`CFG-CAT-01` Pesquisar Categorias](../modules/configuracao/categorias/f-pesquisar-categoria.md) | Configuração da Premiação | SE | 2 | 6 | Médio | 5 | — |
| 6 | Incluir Categoria | [`CFG-CAT-02` Cadastrar Categoria](../modules/configuracao/categorias/f-cadastrar-categoria.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 7 | Consultar Categoria (implícita) | [`CFG-CAT-03` Editar Categoria](../modules/configuracao/categorias/f-editar-categoria.md) | Configuração da Premiação | SE | 2 | 6 | Médio | 5 | — |
| 8 | Editar Categoria | [`CFG-CAT-03` Editar Categoria](../modules/configuracao/categorias/f-editar-categoria.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 9 | Detalhar Categoria | [`CFG-CAT-04` Visualizar Categoria](../modules/configuracao/categorias/f-visualizar-categoria.md) | Configuração da Premiação | SE | — | — | — | 0 | — |
| 10 | Ativar/Inativar Categoria | [`CFG-CAT-05` Ativar/Inativar Categoria](../modules/configuracao/categorias/f-ativar-inativar-categoria.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 11 | Pesquisar Modalidade | [`CFG-MOD-01` Pesquisar Modalidades](../modules/configuracao/modalidades/f-pesquisar-modalidade.md) | Configuração da Premiação | CE | 2 | 6 | Médio | 4 | — |
| 12 | Incluir Modalidade | [`CFG-MOD-02` Cadastrar Modalidade](../modules/configuracao/modalidades/f-cadastrar-modalidade.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 13 | Consultar Modalidade (implícita) | [`CFG-MOD-03` Editar Modalidade](../modules/configuracao/modalidades/f-editar-modalidade.md) | Configuração da Premiação | SE | 2 | 7 | Médio | 5 | — |
| 14 | Editar Modalidade | [`CFG-MOD-03` Editar Modalidade](../modules/configuracao/modalidades/f-editar-modalidade.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 15 | Detalhar Modalidade | [`CFG-MOD-04` Visualizar Modalidade](../modules/configuracao/modalidades/f-visualizar-modalidade.md) | Configuração da Premiação | — | — | — | — | 0 | — |
| 16 | Ativar/Inativar Modalidade | [`CFG-MOD-05` Ativar/Inativar Modalidade](../modules/configuracao/modalidades/f-ativar-inativar-modalidade.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 17 | Pesquisar Tipo de Participante | [`CFG-TIP-01` Pesquisar Tipos de Participante](../modules/configuracao/tipos-participante/f-pesquisar-tipo-participante.md) | Configuração da Premiação | SE | 1 | 8 | Simples | 4 | — |
| 18 | Incluir Tipo de Participante | [`CFG-TIP-02` Cadastrar Tipo de Participante](../modules/configuracao/tipos-participante/f-cadastrar-tipo-participante.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 19 | Consutar Tipo de Participante (implícita) | [`CFG-TIP-03` Editar Tipo de Participante](../modules/configuracao/tipos-participante/f-editar-tipo-participante.md) | Configuração da Premiação | SE | 4 | 15 | Complexo | 7 | — |
| 20 | Editar Tipo de Participante | [`CFG-TIP-03` Editar Tipo de Participante](../modules/configuracao/tipos-participante/f-editar-tipo-participante.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 21 | Detalhar Tipo de Participante | [`CFG-TIP-04` Visualizar Tipo de Participante](../modules/configuracao/tipos-participante/f-visualizar-tipo-participante.md) | Configuração da Premiação | SE | — | — | — | 0 | — |
| 22 | Ativar/Inativar Tipo de Participante | [`CFG-TIP-05` Ativar/Inativar Tipo de Participante](../modules/configuracao/tipos-participante/f-ativar-inativar-tipo-participante.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 23 | Pesquisar Listas do Sistema | [`CFG-LIS-01` Pesquisar Listas](../modules/configuracao/listas-sistema/f-pesquisar-lista.md) | Configuração da Premiação | CE | 1 | 4 | Simples | 3 | — |
| 24 | Incluir Lista do Sistema | [`CFG-LIS-02` Cadastrar Lista](../modules/configuracao/listas-sistema/f-cadastrar-lista.md) | Configuração da Premiação | EE | 1 | 7 | Simples | 3 | — |
| 25 | Consultar Lista do Sisetma (implícita) | [`CFG-LIS-03` Editar Lista](../modules/configuracao/listas-sistema/f-editar-lista.md) | Configuração da Premiação | CE | 1 | 6 | Simples | 3 | — |
| 26 | Editar Lista do Sistema | [`CFG-LIS-03` Editar Lista](../modules/configuracao/listas-sistema/f-editar-lista.md) | Configuração da Premiação | EE | 1 | 7 | Simples | 3 | — |
| 27 | Excluir Lista do Sistema | [`CFG-LIS-04` Excluir Lista](../modules/configuracao/listas-sistema/f-excluir-lista.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 28 | Ordenar Lista | [`CFG-LIS-05` Configurar Itens da Lista](../modules/configuracao/listas-sistema/f-configurar-itens-lista.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 29 | Pesquisar Premiações | [`CFG-PRE-01` Pesquisar Prêmios](../modules/configuracao/premios/f-pesquisar-premio.md) | Configuração da Premiação | SE | 1 | 7 | Simples | 4 | — |
| 30 | Incluir Prêmio | [`CFG-PRE-02` Cadastrar Prêmio](../modules/configuracao/premios/f-cadastrar-premio.md) | Configuração da Premiação | EE | 1 | 6 | Simples | 3 | — |
| 31 | Consultar Links Públicos de Inscrição | [`CFG-PRE-08` Consultar Links Públicos](../modules/configuracao/premios/f-consultar-link-publico.md) | Configuração da Premiação | CE | 1 | 3 | Simples | 3 | — |
| 32 | Gerar Novo Link | [`CFG-PRE-07` Gerar Link Público](../modules/configuracao/premios/f-gerar-link-publico.md) | Configuração da Premiação | EE | 4 | 5 | Complexo | 6 | — |
| 33 | Consultar Categorias (combo) | — *(combo)* | — | CE | 2 | 3 | Simples | 3 | — |
| 34 | Listar Termos de Aceite | [`CFG-PRE-09` Cadastrar Termo de Aceite](../modules/configuracao/premios/f-cadastrar-termo-aceite.md) | Configuração da Premiação | CE | 1 | 5 | Simples | 3 | — |
| 35 | Incluir Termo de Aceite | [`CFG-PRE-09` Cadastrar Termo de Aceite](../modules/configuracao/premios/f-cadastrar-termo-aceite.md) | Configuração da Premiação | EE | 1 | 5 | Simples | 3 | — |
| 36 | Consultar Termo de Aceite (implícita) | [`CFG-PRE-10` Editar Termo de Aceite](../modules/configuracao/premios/f-editar-termo-aceite.md) | Configuração da Premiação | CE | 1 | 4 | Simples | 3 | — |
| 37 | Editar Termo de Aceite | [`CFG-PRE-10` Editar Termo de Aceite](../modules/configuracao/premios/f-editar-termo-aceite.md) | Configuração da Premiação | EE | 1 | 5 | Simples | 3 | — |
| 38 | Excluir Termo de Aceite | [`CFG-PRE-11` Excluir Termo de Aceite](../modules/configuracao/premios/f-excluir-termo-aceite.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 39 | Consultar Template de E-mail (implícita) | [`CFG-EMA-01` Consultar Modelos de E-mail](../modules/configuracao/modelos-email/f-consultar-modelo-email.md) | Configuração da Premiação | CE | 1 | 6 | Simples | 3 | — |
| 40 | Editar Template de E-mail | [`CFG-EMA-02` Editar Modelo de E-mail](../modules/configuracao/modelos-email/f-editar-modelo-email.md) | Configuração da Premiação | EE | 1 | 5 | Simples | 3 | — |
| 41 | Visualizar E-mail | [`CFG-EMA-03` Visualizar E-mail](../modules/configuracao/modelos-email/f-visualizar-email.md) | Configuração da Premiação | CE | 1 | 10 | Simples | 3 | — |
| 42 | Consultar Categorias (lista/pesquisa) | [`CFG-VIN-01` Consultar Estrutura da Premiação](../modules/configuracao/ofertas/f-consultar-estrutura-premiacao.md) | Configuração da Premiação | CE | 1 | 3 | Simples | 3 | — |
| 43 | Copiar Categoria | [`CFG-VIN-02` Vincular Categoria](../modules/configuracao/ofertas/f-vincular-categoria.md) | Configuração da Premiação | EE | 2 | 3 | Simples | 3 | — |
| 44 | Criar e Vincular Categoria | [`CFG-VIN-02` Vincular Categoria](../modules/configuracao/ofertas/f-vincular-categoria.md) | Configuração da Premiação | EE | 2 | 4 | Simples | 3 | — |
| 45 | Copiar Modalidade | [`CFG-VIN-04` Vincular Modalidade](../modules/configuracao/ofertas/f-vincular-modalidade.md) | Configuração da Premiação | EE | 2 | 3 | Simples | 3 | — |
| 46 | Criar e Vincular Modalidade | [`CFG-VIN-04` Vincular Modalidade](../modules/configuracao/ofertas/f-vincular-modalidade.md) | Configuração da Premiação | EE | 2 | 7 | Médio | 4 | — |
| 47 | Consultar Modalidade (lista/pesquisa) | [`CFG-VIN-01` Consultar Estrutura da Premiação](../modules/configuracao/ofertas/f-consultar-estrutura-premiacao.md) | Configuração da Premiação | CE | 1 | 2 | Simples | 3 | — |
| 48 | Duplicar Categoria | [`CFG-VIN-08` Duplicar Oferta](../modules/configuracao/ofertas/f-duplicar-oferta.md) | Configuração da Premiação | EE | 4 | 3 | Médio | 4 | — |
| 49 | Desvincular Categoria | [`CFG-VIN-03` Desvincular Categoria](../modules/configuracao/ofertas/f-desvincular-categoria.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 50 | Copiar Tipo de Participante | [`CFG-VIN-06` Vincular Tipo de Participante](../modules/configuracao/ofertas/f-vincular-tipo-participante.md) | Configuração da Premiação | EE | 4 | 3 | Médio | 4 | — |
| 51 | Duplicar Modalidade | [`CFG-VIN-08` Duplicar Oferta](../modules/configuracao/ofertas/f-duplicar-oferta.md) | Configuração da Premiação | EE | 4 | 3 | Médio | 4 | — |
| 52 | Desvincular Modalidade | [`CFG-VIN-05` Desvincular Modalidade](../modules/configuracao/ofertas/f-desvincular-modalidade.md) | Configuração da Premiação | EE | 2 | 3 | Simples | 3 | — |
| 53 | Duplicar Tipo de Participante | [`CFG-VIN-08` Duplicar Oferta](../modules/configuracao/ofertas/f-duplicar-oferta.md) | Configuração da Premiação | EE | 4 | 3 | Médio | 4 | — |
| 54 | Desvincular Tipo de Participante | [`CFG-VIN-07` Desvincular Tipo de Participante](../modules/configuracao/ofertas/f-desvincular-tipo-participante.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 55 | Configurar Estrutura do Formulário de Inscrição | [`CFG-TIP-06` Configurar Formulário de Inscrição](../modules/configuracao/tipos-participante/f-configurar-formulario.md) | Configuração da Premiação | EE | 1 | 10 | Simples | 3 | — |
| 56 | Consultar Estrutura do Formulário de Inscrição (implícita) | [`CFG-TIP-06` Configurar Formulário de Inscrição](../modules/configuracao/tipos-participante/f-configurar-formulario.md) | Configuração da Premiação | CE | 4 | 9 | Complexo | 6 | — |
| 57 | Visualizar Preview do Formulário | — *(sem-feature)* | — | CE | 4 | 9 | Complexo | 6 | — |
| 58 | Adicionar Campo | [`CFG-TIP-07` Cadastrar Campo](../modules/configuracao/tipos-participante/f-cadastrar-campo.md) | Configuração da Premiação | EE | 1 | 24 | Médio | 4 | — |
| 59 | Consultar Campo (implícito) | [`CFG-TIP-08` Editar Campo](../modules/configuracao/tipos-participante/f-editar-campo.md) | Configuração da Premiação | CE | 4 | 23 | Complexo | 6 | — |
| 60 | Editar Campo | [`CFG-TIP-08` Editar Campo](../modules/configuracao/tipos-participante/f-editar-campo.md) | Configuração da Premiação | EE | 1 | 24 | Médio | 4 | — |
| 61 | Excluir Campo | [`CFG-TIP-09` Excluir Campo](../modules/configuracao/tipos-participante/f-excluir-campo.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 62 | Listar Submodalidades | [`CFG-VIN-09` Cadastrar Submodalidade](../modules/configuracao/ofertas/f-cadastrar-submodalidade.md) | Configuração da Premiação | CE | 4 | 3 | Médio | 4 | — |
| 63 | Incluir Submodalidades | [`CFG-VIN-09` Cadastrar Submodalidade](../modules/configuracao/ofertas/f-cadastrar-submodalidade.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 64 | Consultar Submodalidade (implícita) | [`CFG-VIN-10` Editar Submodalidade](../modules/configuracao/ofertas/f-editar-submodalidade.md) | Configuração da Premiação | CE | 4 | 3 | Médio | 4 | — |
| 65 | Editar Submodalidade | [`CFG-VIN-10` Editar Submodalidade](../modules/configuracao/ofertas/f-editar-submodalidade.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 66 | Ativar/Desativar Submodalidade | [`CFG-VIN-11` Ativar/Inativar Submodalidade](../modules/configuracao/ofertas/f-ativar-inativar-submodalidade.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 67 | Listar Configuração de Equipe | [`CFG-TIP-15` Configurar Equipe](../modules/configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | CE | 4 | 3 | Médio | 4 | — |
| 68 | Incluir Tipo de Vínculo | [`CFG-TIP-15` Configurar Equipe](../modules/configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 69 | Consultar Tipo de Vínculo (implícita) | [`CFG-TIP-15` Configurar Equipe](../modules/configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | CE | 4 | 3 | Médio | 4 | — |
| 70 | Editar Tipo de Vínculo | [`CFG-TIP-15` Configurar Equipe](../modules/configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | EE | 1 | 4 | Simples | 3 | — |
| 71 | Desativar Tipo de Vínculo | [`CFG-TIP-15` Configurar Equipe](../modules/configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 72 | Listar Configuração de Anexos | [`CFG-TIP-12` Configurar Anexos Exigidos](../modules/configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | CE | 4 | 6 | Complexo | 6 | — |
| 73 | Incluir Configuração de Anexo | [`CFG-TIP-12` Configurar Anexos Exigidos](../modules/configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | EE | 1 | 7 | Simples | 3 | — |
| 74 | Consultar Configuração de Anexo | [`CFG-TIP-12` Configurar Anexos Exigidos](../modules/configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | CE | 4 | 6 | Complexo | 6 | — |
| 75 | Editar Configuração de Anexo | [`CFG-TIP-12` Configurar Anexos Exigidos](../modules/configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | EE | 1 | 7 | Simples | 3 | — |
| 76 | Desativar Configuração de Anexo | [`CFG-TIP-12` Configurar Anexos Exigidos](../modules/configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | EE | 1 | 3 | Simples | 3 | — |
| 77 | Consultar Questões do Questionário Avaliação | [`CFG-TIP-13` Cadastrar Questão](../modules/configuracao/tipos-participante/f-cadastrar-questao.md) | Configuração da Premiação | CE | 4 | 6 | Complexo | 6 | — |
| 78 | Incluir Questão do Questionário Avaliação | [`CFG-TIP-13` Cadastrar Questão](../modules/configuracao/tipos-participante/f-cadastrar-questao.md) | Configuração da Premiação | EE | 1 | 9 | Simples | 3 | — |
| 79 | Consultar Questão do Questionário Avaliação (implícita) | [`CFG-TIP-14` Editar Questão](../modules/configuracao/tipos-participante/f-editar-questao.md) | Configuração da Premiação | CE | 4 | 8 | Complexo | 6 | — |
| 80 | Editar Questão do Questionário Avaliação | [`CFG-TIP-14` Editar Questão](../modules/configuracao/tipos-participante/f-editar-questao.md) | Configuração da Premiação | EE | 1 | 9 | Simples | 3 | — |
| 81 | Importar Configuração Excel | [`CFG-TIP-16` Importar Configuração do Tipo de Participante](../modules/configuracao/tipos-participante/f-importar-configuracao.md) | Configuração da Premiação | EE | 4 | 32 | Complexo | 6 | — |
| 82 | Consultar Dashboard do Participante | [`INS-ACO-01` Acompanhar Inscrição](../modules/inscricao/acompanhamento/f-acompanhar-inscricao.md) | Inscrição | SE | 5 | 18 | Complexo | 7 | — |
| 83 | Consultar Notificações | [`INS-NOT-01` Consultar Notificações](../modules/inscricao/notificacoes/f-consultar-notificacao.md) | Inscrição | SE | 3 | 5 | Simples | 4 | — |
| 84 | Marcar Notificação como Lida | [`INS-NOT-02` Marcar Notificação como Lida](../modules/inscricao/notificacoes/f-marcar-notificacao-lida.md) | Inscrição | EE | 1 | 3 | Simples | 3 | — |
| 85 | Realizar Inscrição (Rascunho) | [`INS-PAR-01` Cadastrar Inscrição](../modules/inscricao/inscricao-participante/f-cadastrar-inscricao.md) | Inscrição | EE | 3 | 27 | Complexo | 6 | — |
| 86 | Finalizar Inscrição | [`INS-PAR-03` Finalizar Inscrição](../modules/inscricao/inscricao-participante/f-finalizar-inscricao.md) | Inscrição | EE | 1 | 4 | Simples | 3 | — |
| 87 | Editar Inscrição | [`INS-PAR-02` Editar Inscrição](../modules/inscricao/inscricao-participante/f-editar-inscricao.md) | Inscrição | EE | 2 | 27 | Complexo | 6 | — |
| 88 | Realizar Ajuste na Inscrição | [`INS-PAR-04` Reenviar Inscrição](../modules/inscricao/inscricao-participante/f-reenviar-inscricao.md) | Inscrição | — | — | — | — | 0 | — |
| 89 | Reenviar Inscrição | [`INS-PAR-04` Reenviar Inscrição](../modules/inscricao/inscricao-participante/f-reenviar-inscricao.md) | Inscrição | EE | 2 | 4 | Simples | 3 | — |
| 90 | Consultar Termo de Aceite | [`INS-PAR-06` Aceitar Termo](../modules/inscricao/inscricao-participante/f-aceitar-termo.md) | Inscrição | CE | 2 | 3 | Simples | 3 | — |
| 91 | Consultar Dashboard Validação de Inscrições | [`VAL-FIL-01` Pesquisar Inscrições para Validação](../modules/validacao/fila-validacao/f-pesquisar-inscricao.md) | Validação | SE | 5 | 14 | Complexo | 7 | — |
| 92 | Consultar Premiação (combo) | — *(combo)* | — | CE | 1 | 2 | Simples | 3 | — |
| 93 | Consultar Categoria por Premiação (combo) | — *(combo)* | — | CE | 2 | 3 | Simples | 3 | — |
| 94 | Consultar Modalidade por Categoria (combo) | — *(combo)* | — | CE | 3 | 3 | Simples | 3 | — |
| 95 | Consultar Tipo de Participante por Modalidade (combo) | — *(combo)* | — | CE | 3 | 3 | Simples | 3 | — |
| 96 | Detalhar Inscrição | [`VAL-ANA-01` Detalhar Inscrição](../modules/validacao/analise-decisao/f-detalhar-inscricao.md) | Validação | SE | 5 | 37 | Complexo | 7 | — |
| 97 | Iniciar Validação da Inscrição | [`VAL-ANA-02` Iniciar Validação](../modules/validacao/analise-decisao/f-iniciar-validacao.md) | Validação | EE | 1 | 3 | Simples | 3 | — |
| 98 | Aceitar / Rejeitar Inscrição | [`VAL-ANA-03` Aprovar Inscrição](../modules/validacao/analise-decisao/f-aprovar-inscricao.md) | Validação | EE | 3 | 7 | Complexo | 6 | — |
| 99 | Consultar Auditoria de Ajustes | [`VAL-AJU-02` Consultar Auditoria de Ajustes](../modules/validacao/ajustes/f-consultar-auditoria-ajustes.md) | Validação | SE | 2 | 13 | Médio | 5 | — |
| 100 | Consultar Rodadas (combo) | — *(combo)* | — | CE | 2 | 3 | Simples | 3 | — |
| 101 | Exportar Auditoria de Ajustes para CSV | [`VAL-AJU-03` Exportar Auditoria de Ajustes](../modules/validacao/ajustes/f-exportar-auditoria-ajustes.md) | Validação | CE | 2 | 11 | Médio | 4 | — |
| 102 | Editar Inscrição | — *(sem-feature)* | — | EE | 2 | 27 | Complexo | 6 | — |
| 103 | Excluir Inscrição | — *(sem-feature)* | — | EE | 1 | 3 | Simples | 3 | — |
| 104 | Solicitar Ajuste | [`VAL-AJU-01` Solicitar Ajuste](../modules/validacao/ajustes/f-solicitar-ajuste.md) | Validação | EE | 3 | 5 | Complexo | 6 | — |
| 105 | Consultar Configurações Avaliação e Etapas (implícita) | [`AVL-ETA-01` Configurar Avaliação](../modules/avaliacao/etapas-configuracao/f-configurar-avaliacao.md) | Avaliação | SE | 2 | 16 | Médio | 5 | — |
| 106 | Alterar Configurações Avaliações e Etapas | [`AVL-ETA-01` Configurar Avaliação](../modules/avaliacao/etapas-configuracao/f-configurar-avaliacao.md) | Avaliação | EE | 1 | 6 | Simples | 3 | — |
| 107 | Cadastrar Nova Etapa | [`AVL-ETA-02` Cadastrar Etapa](../modules/avaliacao/etapas-configuracao/f-cadastrar-etapa.md) | Avaliação | EE | 1 | 7 | Simples | 3 | — |
| 108 | Consultar Etapa (implícita) | [`AVL-ETA-03` Editar Etapa](../modules/avaliacao/etapas-configuracao/f-editar-etapa.md) | Avaliação | CE | — | — | — | 0 | **Não contada — os dados não atravessam a fronteira.** A consulta "implícita" é a leitura que precede a edição: na tela de pesquisa aparecem algumas colunas e, ao acionar Editar, o formulário abre com **todos** os campos preenchidos. Ela só é um PE quando essa abertura traz dado que a pesquisa não mostrava. Aqui a lista de etapas já exibe tudo o que o formulário edita, então nada cruza a fronteira de novo. *(critério da equipe de métricas, registrado em 2026-09-02)* |
| 109 | Editar Etapa | [`AVL-ETA-03` Editar Etapa](../modules/avaliacao/etapas-configuracao/f-editar-etapa.md) | Avaliação | EE | 1 | 7 | Simples | 3 | — |
| 110 | Excluir Etapa | [`AVL-ETA-04` Excluir Etapa](../modules/avaliacao/etapas-configuracao/f-excluir-etapa.md) | Avaliação | EE | 1 | 3 | Simples | 3 | — |
| 111 | Alterar ordem das etapas | [`AVL-ETA-05` Reordenar Etapas](../modules/avaliacao/etapas-configuracao/f-reordenar-etapa.md) | Avaliação | EE | 1 | 4 | Simples | 3 | — |
| 112 | Consultar Etapa por Premiação (combo) | — *(combo)* | — | CE | 1 | 4 | Simples | 3 | — |
| 113 | Consultar Alocação de Avaliadores | [`AVL-ALO-01` Consultar Alocação de Avaliadores](../modules/avaliacao/alocacao/f-consultar-alocacao-avaliadores.md) | Avaliação | SE | 5 | 21 | Complexo | 7 | — |
| 114 | Salvar Pool | [`AVL-ALO-02` Alocar Avaliador ao Grupo](../modules/avaliacao/alocacao/f-alocar-avaliador-grupo.md) | Avaliação | EE | 1 | 4 | Simples | 3 | — |
| 115 | Cadastrar Avaliador | [`AVL-ALO-03` Cadastrar Avaliador](../modules/avaliacao/alocacao/f-cadastrar-avaliador.md) | Avaliação | EE | 2 | 7 | Médio | 4 | — |
| 116 | Consultar Alocação de Avaliadores por Participante | [`AVL-ALO-04` Alocar Avaliador à Inscrição](../modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md) | Avaliação | SE | 6 | 18 | Complexo | 7 | — |
| 117 | Consultar Grupo (combo) | — *(combo)* | — | CE | 4 | 4 | Médio | 4 | — |
| 118 | Consultar Avaliadores por Inscrição | [`AVL-ALO-04` Alocar Avaliador à Inscrição](../modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md) | Avaliação | SE | 4 | 10 | Complexo | 7 | — |
| 119 | Incluir Avaliadores para Inscrição | [`AVL-ALO-04` Alocar Avaliador à Inscrição](../modules/avaliacao/alocacao/f-alocar-avaliador-inscricao.md) | Avaliação | EE | 2 | 3 | Simples | 3 | — |
| 120 | Consultar Painel de Avaliações | [`AVL-PAI-01` Acompanhar Painel de Avaliações](../modules/avaliacao/painel-administrativo/f-acompanhar-painel-avaliacoes.md) | Avaliação | SE | 5 | 20 | Complexo | 7 | — |
| 121 | Consultar Etapas por Inscrição | — *(combo)* | — | CE | 2 | 5 | Simples | 3 | — |
| 122 | Consultar Avaliações por Etapa | [`AVL-PAI-02` Consultar Avaliações por Etapa](../modules/avaliacao/painel-administrativo/f-consultar-avaliacoes-etapa.md) | Avaliação | SE | 3 | 5 | Simples | 4 | — |
| 123 | Visualizar Avaliações | [`AVL-PAI-02` Consultar Avaliações por Etapa](../modules/avaliacao/painel-administrativo/f-consultar-avaliacoes-etapa.md) | Avaliação | SE | 6 | 20 | Complexo | 7 | — |
| 124 | Consolidar Avaliação | [`AVL-PAI-03` Consolidar Avaliação](../modules/avaliacao/painel-administrativo/f-consolidar-avaliacao.md) | Avaliação | EE | 1 | 3 | Simples | 3 | — |
| 125 | Pré-visualizar Consolidação | [`AVL-PAI-03` Consolidar Avaliação](../modules/avaliacao/painel-administrativo/f-consolidar-avaliacao.md) | Avaliação | CE | 1 | 2 | Simples | 3 | — |
| 126 | Gerar com IA | [`AVL-APU-04` Gerar Devolutiva com IA](../modules/avaliacao/apuracao-devolutiva/f-gerar-devolutiva-ia.md) | Avaliação | SE | 2 | 3 | Simples | 4 | — |
| 127 | Consultar Painel Minhas Avaliações | [`AVL-AVA-01` Acompanhar Minhas Avaliações](../modules/avaliacao/avaliacao-projetos/f-acompanhar-minhas-avaliacoes.md) | Avaliação | SE | 7 | 18 | Complexo | 7 | — |
| 128 | Consultar Avaliação (implícita) | [`AVL-AVA-03` Avaliar Inscrição](../modules/avaliacao/avaliacao-projetos/f-avaliar-inscricao.md) | Avaliação | SE | 7 | 31 | Complexo | 7 | — |
| 129 | Salvar Avaliação | [`AVL-AVA-03` Avaliar Inscrição](../modules/avaliacao/avaliacao-projetos/f-avaliar-inscricao.md) | Avaliação | EE | 1 | 5 | Simples | 3 | — |
| 130 | Finalizar Avaliação | [`AVL-AVA-04` Finalizar Avaliação](../modules/avaliacao/avaliacao-projetos/f-finalizar-avaliacao.md) | Avaliação | EE | 1 | 3 | Simples | 3 | — |
| 131 | Reabrir Avaliação | [`AVL-AVA-05` Reabrir Avaliação](../modules/avaliacao/avaliacao-projetos/f-reabrir-avaliacao.md) | Avaliação | EE | 1 | 3 | Simples | 3 | — |
| 132 | Consultar Termos de Aceite por Prêmios | [`AVL-AVA-02` Aceitar Termo de Confidencialidade](../modules/avaliacao/avaliacao-projetos/f-aceitar-termo-confidencialidade.md) | Avaliação | CE | 1 | 3 | Simples | 3 | — |
| 133 | Visualizar Termo de Aceite | [`AVL-AVA-02` Aceitar Termo de Confidencialidade](../modules/avaliacao/avaliacao-projetos/f-aceitar-termo-confidencialidade.md) | Avaliação | CE | 1 | 2 | Simples | 3 | — |
| 134 | Aceitar Termo de Aceite | [`AVL-AVA-02` Aceitar Termo de Confidencialidade](../modules/avaliacao/avaliacao-projetos/f-aceitar-termo-confidencialidade.md) | Avaliação | EE | 1 | 3 | Simples | 3 | — |
| 135 | Configurar Critérios de Desempate | [`AVL-ETA-06` Configurar Critérios de Desempate](../modules/avaliacao/etapas-configuracao/f-configurar-criterios-desempate.md) | Avaliação | EE | — | 11 | Simples | 3 | — |
| 136 | Consultar Critérios de Desempate | [`AVL-ETA-06` Configurar Critérios de Desempate](../modules/avaliacao/etapas-configuracao/f-configurar-criterios-desempate.md) | Avaliação | CE | — | 10 | Simples | 3 | — |
| 137 | Relatório de Inscrições Paradas | [`AVL-APU-06` Gerar Relatório de Inscrições Paradas](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md) | Avaliação | SE | 5 | 37 | Complexo | 7 | — |
| 138 | Exportar Relatório de Inscrições Paradas para Excel | [`AVL-APU-06` Gerar Relatório de Inscrições Paradas](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md) | Avaliação | SE | 5 | 37 | Complexo | 7 | — |
| 139 | Consultar Dashboard Gerencial | [`VAL-FIL-02` Acompanhar Painel de Validação](../modules/validacao/fila-validacao/f-acompanhar-painel-validacao.md) | Validação | SE | 4 | 12 | Complexo | 7 | — |

**Subtotal Funções de Transação: 530 PF** (139 PE).

### Memória de cálculo — Funções de Transação

<details><summary>ALR e DER nomeados de cada processo elementar</summary>

1. **Pesquisar Usuários** — ALR (1): Usuário. DER (10): Entidade · Perfil · Nome · Login · Email · Situação · Data Cadastro · Data Atualização · Ação · Mensagem.
2. **Incluir Usuário** — ALR (1): Usuário. DER (12): Login · Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação · Mensagem.
3. **Consultar Usuário (implícito)** — ALR (1): Usuário. DER (11): Login · Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação.
4. **Editar Usuário** — ALR (1): Usuário. DER (11): Nome · CPF · Telefone · Celular · Email · Cargo · Perfil · UF Atuação · Entidade · Ação · Mensagem.
5. **Pesquisar Categorias** — ALR (2): Categoria · Premiação. DER (6): Nome · Descrição · Qtd Vinculos · Status · Ação · Mensagem.
6. **Incluir Categoria** — ALR (1): Categoria · Premiação. DER (4): Nome · Descrição · Ação · Mensagem.
7. **Consultar Categoria (implícita)** — ALR (2): Categoria · Premiação. DER (6): Nome · Descrição · Premiação · Id do Vinculo · Situação · Ação.
8. **Editar Categoria** — ALR (1): Categoria · Premiação. DER (4): Nome · Descrição · Ação · Mensagem.
9. **Detalhar Categoria** — ALR (0): —. DER (0): —.
10. **Ativar/Inativar Categoria** — ALR (1): Categoria. DER (3): ID Categoria · Ação · Mensagem.
11. **Pesquisar Modalidade** — ALR (2): Modalidade · Tipo Participante. DER (6): Nome · Descrição · Qtd Tipos Participantes · Situação · Ação · Mensagem.
12. **Incluir Modalidade** — ALR (1): Modalidade. DER (4): Nome · Descrição · Ação · Mensagem.
13. **Consultar Modalidade (implícita)** — ALR (2): Modalidade · Categoria. DER (7): Nome · Descrição · Premiação · Categoria · Id do Vinculo · Situação · Ação.
14. **Editar Modalidade** — ALR (1): Modalidade. DER (4): Nome · Descrição · Ação · Mensagem.
15. **Detalhar Modalidade** — ALR (0): —. DER (0): —.
16. **Ativar/Inativar Modalidade** — ALR (1): Modalidade. DER (3): ID · Ação · Mensagem.
17. **Pesquisar Tipo de Participante** — ALR (1): Tipo de Participante. DER (8): Nome · Situação · Descrição · Formulário · Qtd Campos · Situação · Ação · Mensagem.
18. **Incluir Tipo de Participante** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.
19. **Consutar Tipo de Participante (implícita)** — ALR (4): Tipo Participante · Premiação · Modalidade · Categoria. DER (15): Nome · Descrição · Premiação · Categoria · Modalidade · ID do Vinculo · Situação · Seção · Campo · Sub Modalidades · Equipe · Anexos · Questionário · Qtd questões · Ações.
20. **Editar Tipo de Participante** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.
21. **Detalhar Tipo de Participante** — ALR (0): —. DER (0): —.
22. **Ativar/Inativar Tipo de Participante** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.
23. **Pesquisar Listas do Sistema** — ALR (1): Listas do Sistema. DER (4): Nome · Código · Ação · Mensagem.
24. **Incluir Lista do Sistema** — ALR (1): Listas do Sistema. DER (7): Nome · Código · Valor · Texto · Ordem · Ação · Mensagem.
25. **Consultar Lista do Sisetma (implícita)** — ALR (1): Listas do Sistema. DER (6): Nome · Código · Valor · Texto · Ordem · Ação.
26. **Editar Lista do Sistema** — ALR (1): Listas do Sistema. DER (7): Nome · Código · Valor · Texto · Ordem · Ação · Mensagem.
27. **Excluir Lista do Sistema** — ALR (1): Listas do Sistema. DER (3): ID · Ação · Mensagem.
28. **Ordenar Lista** — ALR (1): Listas do Sistema. DER (3): ID · Ação · Mensagem.
29. **Pesquisar Premiações** — ALR (1): Premiação. DER (7): Nome · Período · Data de Início · Data Fim · Qtd Categoria · Ação · Mensagem.
30. **Incluir Prêmio** — ALR (1): Premiação. DER (6): Nome · Descrição · Data Início · Data Fim · Ação · Mensagem.
31. **Consultar Links Públicos de Inscrição** — ALR (1): Premiação. DER (3): Tipo de Participante · URL · Ação.
32. **Gerar Novo Link** — ALR (4): Premiação · Categoria · Modalidade · Tipo de Participante. DER (5): Categoria · Modalidade · Tipo de Participante · Ação · Mensagem.
33. **Consultar Categorias (combo)** — ALR (2): Premiação · Categoria. DER (3): Premiação · Categoria · Ação.
34. **Listar Termos de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Versão · Ação · Mensagem.
35. **Incluir Termo de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Texto · Ação · Mensagem.
36. **Consultar Termo de Aceite (implícita)** — ALR (1): Premiação. DER (4): Titulo · Obrigatório · Texto · Ação.
37. **Editar Termo de Aceite** — ALR (1): Premiação. DER (5): Titulo · Obrigatório · Texto · Ação · Mensagem.
38. **Excluir Termo de Aceite** — ALR (1): Premiação. DER (3): ID · Ação · Mensagem.
39. **Consultar Template de E-mail (implícita)** — ALR (1): Premiação. DER (6): Tipo de E-mail · Assunto do E-mail · Corpo do E-mail · Placeholders · Ação · Mensagem.
40. **Editar Template de E-mail** — ALR (1): Premiação. DER (5): Tipo de E-mail · Assunto do E-mail · Corpo do E-mail · Ação · Mensagem.
41. **Visualizar E-mail** — ALR (1): Premiação. DER (10): Prêmio · Nome do Participante · Titulo da Premiação · Nome da Categoria · Nome da Modalidade · Número do Protocolo · Texto do Ajuste · Texto do Parecer · Nome do Administrador · Ação.
42. **Consultar Categorias (lista/pesquisa)** — ALR (1): Categoria. DER (3): Nome · Ação · Mensagem.
43. **Copiar Categoria** — ALR (2): Categoria · Premiação. DER (3): ID · Ação · Mensagem.
44. **Criar e Vincular Categoria** — ALR (2): Categoria · Premiação. DER (4): Nome · Descrição · Ação · Mensagem.
45. **Copiar Modalidade** — ALR (2): Modalidade · Premiação. DER (3): ID · Ação · Mensagem.
46. **Criar e Vincular Modalidade** — ALR (2): Modalidade · Premiação. DER (7): Nome · Descrição · Link do Regulamento · Data Início Período Inscrição · Data Fim Período Inscrição · Ação · Mensagem.
47. **Consultar Modalidade (lista/pesquisa)** — ALR (1): Modalidade. DER (2): Modalidade · Ação.
48. **Duplicar Categoria** — ALR (4): Categoria · Modalidade · Tipo Participante · Premiação. DER (3): Identificador · Ação · Mensagem.
49. **Desvincular Categoria** — ALR (1): Categoria. DER (3): ID · Ação · Mensagem.
50. **Copiar Tipo de Participante** — ALR (4): Premiação · Tipo de Participante · Categoria · Modalidade. DER (3): ID · Ação · Mensagem.
51. **Duplicar Modalidade** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Identificador · Ação · Mensagem.
52. **Desvincular Modalidade** — ALR (2): Modalidade · Premiação. DER (3): ID · Ação · Mensagem.
53. **Duplicar Tipo de Participante** — ALR (4): Premiação · Tipo de Participante · Categoria · Modalidade. DER (3): Identificador · Ação · Mensagem.
54. **Desvincular Tipo de Participante** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.
55. **Configurar Estrutura do Formulário de Inscrição** — ALR (1): Tipo Participante. DER (10): Cor primária · Fundo · Rótulos · Imagem Banner · Título · Subtítulo · Descrição Rica · Layout · Ação · Mensagem.
56. **Consultar Estrutura do Formulário de Inscrição (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (9): Cor primária · Fundo · Rótulos · Imagem Banner · Título · Subtítulo · Descrição Rica · Layout · Ação.
57. **Visualizar Preview do Formulário** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (9): Título · Título Questão · Título Questão de Avaliação · Tipo Questão · Campo obrigatório · Tamanho Máximo · Opções Campo · Peso · Ação.
58. **Adicionar Campo** — ALR (1): Tipo Participante. DER (24): Rotulo · Descrição · Obrigatório · Tamanho · Máscara predefinida · Min caracteres · Max caracteres · Ícone · Tooltip · Placeholder · Tamanho · Espaçamento · Classe CSS · Opções (usar lista do sistema) · Valor · Texto exibido · Extensões permitidas · Tamanho máximo · Texto do cabeçalho · Texto do link · Título do Modal · Conteúdo · Ação · Mensagem.
59. **Consultar Campo (implícito)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (23): Rotulo · Descrição · Obrigatório · Tamanho · Máscara predefinida · Min caracteres · Max caracteres · Ícone · Tooltip · Placeholder · Tamanho · Espaçamento · Classe CSS · Opções (usar lista do sistema) · Valor · Texto exibido · Extensões permitidas · Tamanho máximo · Texto do cabeçalho · Texto do link · Título do Modal · Conteúdo · Ação.
60. **Editar Campo** — ALR (1): Tipo Participante. DER (24): Rotulo · Descrição · Obrigatório · Tamanho · Máscara predefinida · Min caracteres · Max caracteres · Ícone · Tooltip · Placeholder · Tamanho · Espaçamento · Classe CSS · Opções (usar lista do sistema) · Valor · Texto exibido · Extensões permitidas · Tamanho máximo · Texto do cabeçalho · Texto do link · Título do Modal · Conteúdo · Ação · Mensagem.
61. **Excluir Campo** — ALR (1): Tipo Participante. DER (3): ID Campo · Ação · Mensagem.
62. **Listar Submodalidades** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome · Descrição · Ação.
63. **Incluir Submodalidades** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.
64. **Consultar Submodalidade (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome · Descrição · Ação.
65. **Editar Submodalidade** — ALR (1): Tipo Participante. DER (4): Nome · Descrição · Ação · Mensagem.
66. **Ativar/Desativar Submodalidade** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.
67. **Listar Configuração de Equipe** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome do Vínculo · Ordem · Ação.
68. **Incluir Tipo de Vínculo** — ALR (1): Tipo Participante. DER (4): Nome · Ordem · Ação · Mensagem.
69. **Consultar Tipo de Vínculo (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (3): Nome · Ordem · Ação.
70. **Editar Tipo de Vínculo** — ALR (1): Tipo Participante. DER (4): Nome · Ordem · Ação · Mensagem.
71. **Desativar Tipo de Vínculo** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.
72. **Listar Configuração de Anexos** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Nome do Anexo · Obrigatório · Extensões · Tamanho Max · Ação · Mensagem.
73. **Incluir Configuração de Anexo** — ALR (1): Tipo Participante. DER (7): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação · Mensagem.
74. **Consultar Configuração de Anexo** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação.
75. **Editar Configuração de Anexo** — ALR (1): Tipo Participante. DER (7): Nome do Anexo · Obrigatório · Descrição · Extensões · Tamanho Max · Ação · Mensagem.
76. **Desativar Configuração de Anexo** — ALR (1): Tipo Participante. DER (3): ID · Ação · Mensagem.
77. **Consultar Questões do Questionário Avaliação** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (6): Título · Tipo · Peso · Tamanho · Qtd Alternativas · Ação.
78. **Incluir Questão do Questionário Avaliação** — ALR (1): Tipo Participante. DER (9): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação · Mensagem.
79. **Consultar Questão do Questionário Avaliação (implícita)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (8): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação.
80. **Editar Questão do Questionário Avaliação** — ALR (1): Tipo Participante. DER (9): Titulo · Enunciado · Descrição · Obrigatória · Peso / Nota · Limite de caracteres · Alternativas · Ação · Mensagem.
81. **Importar Configuração Excel** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (32): Nome · Descrição · Data Início · Data Fim · Categoria · Modalidade · Objetivo · Tipo Participante · Enquadramento · Critério · Categoria · Etapa · Rótulo do Campo · Tipo do Campo · Obrigatório · Largura · Descrição/Dica · Tipo Questão · Titulo · Enunciado · Obrigatório · Peso Nota · Limite Caracteres · Alternativas · Obrigatório · Nome Anexo · Descrição · Obrigatório · Extensão Permitida · Tamanho Máximo · Ação · Mensagem.
82. **Consultar Dashboard do Participante** — ALR (5): Premiação · Categoria · Modalidade · Tipo de Participante · Inscrição. DER (18): Nome Usuário · Foto · Total de Inscrições · Status Inscrições · Total Inscrições por Status · Nome Premio · Status Inscrição · Categoria · Modalidade · Tipo Participante · Percentual Inscrição · Número Inscrição · Total Notificações · Titulo Notificação · Descrição Notificação · Qtd Notificações não lidas · Ação · Mensagem.
83. **Consultar Notificações** — ALR (3): Premiação · Inscrição · Notificação Participante. DER (5): Qtd Não Lidas · Titulo · Descrição · Data/Hora · Ação.
84. **Marcar Notificação como Lida** — ALR (1): Notificação Participante. DER (3): Notificação · Ação · Mensagem.
85. **Realizar Inscrição (Rascunho)** — ALR (3): Premiação · Inscrição · Tipo de Participante. DER (27): Percentual Inscrição · Qtd questões preenchidas/Total questões · Título Questão Formulário de Inscrição · Descrição Questão · Obrigatoriedade questão · Resposta · Número Questão Questionário de Avaliação · Título Questão · Tipo Questão · Obrigatoriedade · Peso · Resposta · Qtd min membros equipe · Qtd max membros equipe · Qtd membros cadastrados · Nome membro · CPF · E-mail · Telefone · Genero · Tipo de validação do formulário · Mensagem de validação · Tipo Anexo · Tipo Arquivo · Arquivo · Ação · Mensagem.
86. **Finalizar Inscrição** — ALR (1): Inscrição. DER (4): ID Inscrição · Termo de Aceite · Ação · Mensagem.
87. **Editar Inscrição** — ALR (2): Inscrição · Tipo de Participante. DER (27): Percentual Inscrição · Qtd questões preenchidas/Total questões · Título Questão Formulário de Inscrição · Descrição Questão · Obrigatoriedade questão · Resposta · Número Questão Questionário de Avaliação · Título Questão · Tipo Questão · Obrigatoriedade · Peso · Resposta · Qtd min membros equipe · Qtd max membros equipe · Qtd membros cadastrados · Nome membro · CPF · E-mail · Telefone · Genero · Tipo de validação do formulário · Mensagem de validação · Tipo Anexo · Tipo Arquivo · Arquivo · Ação · Mensagem.
88. **Realizar Ajuste na Inscrição** — ALR (0): —. DER (0): —.
89. **Reenviar Inscrição** — ALR (2): Premiação · Inscrição. DER (4): ID Inscrição · Termo de Aceite · Ação · Mensagem.
90. **Consultar Termo de Aceite** — ALR (2): Premiação · Tipo de Participante. DER (3): Titulo Termo de Aceite · Descrição Termo de Aceite · Ação.
91. **Consultar Dashboard Validação de Inscrições** — ALR (5): Inscrição · Premiação · Categoria · Modalidade · Tipo de Participante. DER (14): Qtd Inscrições · Status Inscrição · Percentual Inscritos por Status · UF · Premiação · Categoria · Modalidade · Tipo Participante · Status · Protocolo · UF · Data Finalização · Ação · Mensagem.
92. **Consultar Premiação (combo)** — ALR (1): Premiação. DER (2): Premiação · Ação.
93. **Consultar Categoria por Premiação (combo)** — ALR (2): Premiação · Categoria. DER (3): Premiação · Categoria · Ação.
94. **Consultar Modalidade por Categoria (combo)** — ALR (3): Premiação · Categoria · Modalidade. DER (3): Categoria · Modalidade · Ação.
95. **Consultar Tipo de Participante por Modalidade (combo)** — ALR (3): Premiação · Modalidade · Tipo de Participante. DER (3): Modalidade · Tipo de Participante · Ação.
96. **Detalhar Inscrição** — ALR (5): Inscrição · Premiação · Categoria · Modalidade · Tipo de Participante. DER (37): Inscrição · Status · E-mail · Prêmio · Categoria · Modalidade · Tipo de Participante · Percentual Campos Preenchidos · Qtd Premios Preenchidos · Qtd arquivos anexados · Qtd membros cadastrados · Qtd termos aceitos · CPF · Data · UF · Anexo · Termos · E-mail · Número · Qtd Questoes do formulário · Título questão · Obrigatoriedade questão · Resposta questão · Nome arquivo · Tipo arquivo · Data anexo · Tamanho · Equipe · E-mail equipe · Telefone · CPF membro equipe · Número Termo · Data/Hora aceite · Histórico de Status · Data/hora mudança de status · Comentário · Ação.
97. **Iniciar Validação da Inscrição** — ALR (1): Inscrição. DER (3): Inscrição · Ação · Mensagem.
98. **Aceitar / Rejeitar Inscrição** — ALR (3): Inscrição · Auditoria de E-mail · Notificação Participante. DER (7): Total de itens para ajustes · Total de itens conferidos · Numero item · Descrição item · Parecer da aprovação · Ação · Mensagem.
99. **Consultar Auditoria de Ajustes** — ALR (2): Inscrição · Tipo de Participante. DER (13): Rodada · Apenas alterações · Data solicitação · Data reenvio · Qtd alterações · Tipo de alteração · Qtd alteração por tipo · Status alteração · Item alterado · Valor anterior · Valor atual · Ação · Mensagem.
100. **Consultar Rodadas (combo)** — ALR (2): Inscrição · Tipo de Participante. DER (3): Rodada · Ação · Mensagem.
101. **Exportar Auditoria de Ajustes para CSV** — ALR (2): Inscrição · Tipo de Participante. DER (11): Rodada · Data Antes · Data Depois · Superficie · Id Registro · Registro · Campo · Valor Antes · Valor Depois · Tipo Operacao · Ação.
102. **Editar Inscrição** — ALR (2): Inscrição · Tipo de Participante. DER (27): Percentual Inscrição · Qtd questões preenchidas/Total questões · Título Questão Formulário de Inscrição · Descrição Questão · Obrigatoriedade questão · Resposta · Número Questão Questionário de Avaliação · Título Questão · Tipo Questão · Obrigatoriedade · Peso · Resposta · Qtd min membros equipe · Qtd max membros equipe · Qtd membros cadastrados · Nome membro · CPF · E-mail · Telefone · Genero · Tipo de validação do formulário · Mensagem de validação · Tipo Anexo · Tipo Arquivo · Arquivo · Ação · Mensagem.
103. **Excluir Inscrição** — ALR (1): Inscrição. DER (3): ID · Ação · Mensagem.
104. **Solicitar Ajuste** — ALR (3): Inscrição · Auditoria de E-mail · Notificação Participante. DER (5): Inscrição · Item de Ajuste · Descrição do Ajuste · Ação · Mensagem.
105. **Consultar Configurações Avaliação e Etapas (implícita)** — ALR (2): Premiação · Tipo de Participante. DER (16): Confidencialidade da avaliação · Mostrar nota agregada... · Pontuação máxima por nota máxima · Pontuação restante · Número etapa · Nome da etapa · Período · Status etapa · Operador etapa · Data liberação feedback · Tipo de Participante · Tipo da Questão · Título da Questão · Enunciado · Peso / Nota · Ação.
106. **Alterar Configurações Avaliações e Etapas** — ALR (1): Premiação. DER (6): Confidencialidade da avaliação · Mostrar nota agregada... · Pontuação máxima por nota máxima · Pontuação restante · Ação · Mensagem.
107. **Cadastrar Nova Etapa** — ALR (1): Premiação. DER (7): Nome da etapa · Início · Fim · Liberação do feedback · Operador da etapa · Ação · Mensagem.
108. **Consultar Etapa (implícita)** — ALR (0): —. DER (0): —. *Sem ALR e sem DER porque nada atravessa a fronteira: a lista de etapas já mostra os campos que o formulário de edição abre preenchidos — ver a coluna Observação.*
109. **Editar Etapa** — ALR (1): Premiação. DER (7): Nome da etapa · Início · Fim · Liberação do feedback · Operador da etapa · Ação · Mensagem.
110. **Excluir Etapa** — ALR (1): Premiação. DER (3): ID · Ação · Mensagem.
111. **Alterar ordem das etapas** — ALR (1): Premiação. DER (4): ID · Ordem · Ação · Mensagem.
112. **Consultar Etapa por Premiação (combo)** — ALR (1): Premiação. DER (4): Etapa · ID Premiação · Ação · Mensagem.
113. **Consultar Alocação de Avaliadores** — ALR (5): Premiação · Tipo Participante · Categoria · Modalidade · Usuário. DER (21): Premio · Etapa · Grupo · Categoria · Modalidade · Tipo de Participante · Status das Inscrições · Total por status · Percentual por status · Total de Inscrições · Qtd de Avaliadores · Total avaliadores no pool · Status pool · Nome avaliador · E-mail avaliador · UF · Qtd avaliações alocadas · Qtd avaliações em andamento · Qtd avaliações finalizadas · Ação · Mensagem.
114. **Salvar Pool** — ALR (1): Alocação Avaliadores. DER (4): ID Avaliador · ID Pool · Ação · Mensagem.
115. **Cadastrar Avaliador** — ALR (2): Alocação Avaliadores · Usuário. DER (7): Login / E-mail AD · Nome Completo · CPF · Cargo / Instituição · UFs de atuação · Ação · Mensagem.
116. **Consultar Alocação de Avaliadores por Participante** — ALR (6): Alocação Avaliadores · Usuário · Avaliação de Inscrição · Categoria · Modalidade · Inscrição. DER (18): Premiação · Etapa · Grupo · Total de Inscrições · Participante · Projeto · Total avaliadores selecionados/necessários · Localidade · Categoria · Modalidade · Tipo de Participante · Avaliador · E-mail avaliador · Total avaliações alocadas · Total avaliações em andamento · Total avaliações finalizadas · Ação · Mensagem.
117. **Consultar Grupo (combo)** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (4): Grupo · ID Premiação · Ação · Mensagem.
118. **Consultar Avaliadores por Inscrição** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (10): Participante · Projeto · Etapa · Localidade · Avaliador · E-mail avaliador · Total avaliações alocadas · Total avaliações em andamento · Total avaliações finalizadas · Ação.
119. **Incluir Avaliadores para Inscrição** — ALR (2): Premiação · Alocação Avaliadores. DER (3): ID Avaliador · Ação · Mensagem.
120. **Consultar Painel de Avaliações** — ALR (5): Premiação · Categoria · Modalidade · Alocação Avaliadores · Avaliação de Inscrição. DER (20): Qtd Avaliadores Alocados · Percentual Avaliadores Alocados · Qtd avaliações em andamento · Percentual avaliações em andamento · Qtd avaliações concluidas · Percentual avaliações concluidas · Qtd avaliações consolidadas · Percentual avaliações consolidadas · Qtd avaliação sem avaliadores · Percentual avaliação sem avaliadores · Número protocolo · Status · Inscrição / Etapa / Avaliador · Premiação · Categoria · Modalidade · Avaliações · Status · Ação · Mensagem.
121. **Consultar Etapas por Inscrição** — ALR (2): Premiação · Avaliação de Inscrição. DER (5): Etapa · Tipo Etapa · Qtd avaliações/avaliações realizadas · Status · Ação.
122. **Consultar Avaliações por Etapa** — ALR (3): Alocação Avaliadores · Usuário · Inscrição. DER (5): Avaliador · Data/hora finalização · Qtd de questões · Status · Ação.
123. **Visualizar Avaliações** — ALR (6): Inscrição · Premiação · Alocação Avaliadores · Usuário · Avaliação de Inscrição · Tipo de Participante. DER (20): Inscrição · Premiação · Modalidade · Categoria · Etapa atual · Qtd avaliações finalizadas/total avaliações · Status da consolidação · Inicial Avaliador · Número Avaliador · Nome Avaliador · Status avaliação · Qtd questões · Nota da questão · Número questão · Descrição questão · Feedback · Feedback consolidado · Status feedback consolidado · Ação · Mensagem.
124. **Consolidar Avaliação** — ALR (1): Avaliação de Inscrição. DER (3): Texto consolidação · Ação · Mensagem.
125. **Pré-visualizar Consolidação** — ALR (1): Avaliação de Inscrição. DER (2): Texto · Ação.
126. **Gerar com IA** — ALR (2): Premiação · Avaliação de Inscrição. DER (3): Texto consolidação · Ação · Mensagem.
127. **Consultar Painel Minhas Avaliações** — ALR (7): Alocação Avaliadores · Avaliação de Inscrição · Premiação · Inscrição · Modalidade · Categoria · Tipo de Participante. DER (18): Nome avaliador · Quantidade de avaliações pendentes · Prazo máximo para avaliação pendentes · Qtd avaliações a iniciar · Qtd avaliações em andamento · Qtd avaliações finalizadas · Premiação · Etapa · Status · Número projeto · Status avaliação da Inscrição · Modalidade · Categoria · Tipo Participante · Percentual de conclusão · Prazo inscrição · Ação · Mensagem.
128. **Consultar Avaliação (implícita)** — ALR (7): Alocação Avaliadores · Avaliação de Inscrição · Premiação · Inscrição · Modalidade · Categoria · Tipo de Participante. DER (31): Etapa · Status · Num projeto · Premiação · Organização · Cidade / UF · E-mail · Categoria · Modalidade · Tipo de Participante · Média Ponderada · Nota · Qtd questões/total pontuadas · Percentual questões pontuadas · Prazo · Qtd avaliadores · Confidencialidade · Anexos · Número questão · Peso · Questão · Resposta Questão · Quantidade estrelas · Nota · Feedback geral · Nome Avaliador (Outros avaliadores) · Data início/fim avaliação · Status avaliação · Transição avaliação (Histórico) · Data/hora transição · Avaliador.
129. **Salvar Avaliação** — ALR (1): Avaliação de Inscrição. DER (5): Questão · Nota questão · Feedback geral · Ação · Mensagem.
130. **Finalizar Avaliação** — ALR (1): Avaliação de Inscrição. DER (3): ID · Ação · Mensagem.
131. **Reabrir Avaliação** — ALR (1): Avaliação de Inscrição. DER (3): ID · Ação · Mensagem.
132. **Consultar Termos de Aceite por Prêmios** — ALR (1): Premiação. DER (3): Prêmio · Status Termo · Ação.
133. **Visualizar Termo de Aceite** — ALR (1): Premiação. DER (2): Termo de Confidencialidade · Ação.
134. **Aceitar Termo de Aceite** — ALR (1): Premiação. DER (3): ID Termo · Ação · Mensagem.
135. **Configurar Critérios de Desempate** — ALR (0): Premiação · Avaliação de Inscrição · Tipo de Participante · Inscrição. DER (11): Tipo de participante · Quetões disponíveis · Questão · Descrição questão · Tipo · Peso · Ordem · Qtd Critérios configurados · Qtd critérios selecionados · Ação · Mensagem.
136. **Consultar Critérios de Desempate** — ALR (0): Premiação · Avaliação de Inscrição · Tipo de Participante · Inscrição. DER (10): Tipo de participante · Quetões disponíveis · Questão · Descrição questão · Tipo · Peso · Ordem · Qtd Critérios configurados · Qtd critérios selecionados · Ação.
137. **Relatório de Inscrições Paradas** — ALR (5): Premiação · Modalidade · Categoria · Tipo de Participante · Inscrição. DER (37): Protocolo · Identificação · E-mail · Categoria · Modalidade · Tipo Participante · Enquadramento · UF · Status · % Preenchimento · Dias Parado · Data Início · Última Atualização · CNPJ · Razão social · Nome fantasia · Estado · Cidade · CEP · Endereço · Site · Redes sociais · Setor · CPF · Nome completo · E-mail · Gênero · Estado · Cidade · CEP · Endereço · Data de nascimento · Telefone · Telefone · Área · Cargo · Ação.
138. **Exportar Relatório de Inscrições Paradas para Excel** — ALR (5): Premiação · Modalidade · Categoria · Tipo de Participante · Inscrição. DER (37): Protocolo · Identificação · E-mail · Categoria · Modalidade · Tipo Participante · Enquadramento · UF · Status · % Preenchimento · Dias Parado · Data Início · Última Atualização · CNPJ · Razão social · Nome fantasia · Estado · Cidade · CEP · Endereço · Site · Redes sociais · Setor · CPF · Nome completo · E-mail · Gênero · Estado · Cidade · CEP · Endereço · Data de nascimento · Telefone · Telefone · Área · Cargo · Ação.
139. **Consultar Dashboard Gerencial** — ALR (4): Premiação · Categoria · Modalidade · Inscrição. DER (12): UF · Premiação · Categoria · Modalidade · Data Inicio · Data Fim · Status · Qtd por Status · Qtd por UF/Status · Qtd por Categoria/Status · Ação · Mensagem.

</details>

---

## 1B. Processos elementares contados fora do baseline (2026-09-01)

Os **12 processos elementares** que a SP05 entregou e que **não existem** na contagem de 2026-02-28 — a capacidade não existia quando o baseline foi levantado. Contados sobre os N3 já escritos, pelas regras do IFPUG CPM 4.3.1 e pelas mesmas convenções de ALR do baseline. A memória de cálculo de cada um vive na seção `## Métricas de tamanho` do respectivo N3.

⚠️ **Pendente de validação pela equipe de métricas.** Enquanto não houver validação, estes 77 PF são contagem própria, não medida homologada — e o baseline de 2026-02-28 permanece intacto na seção 1.

| # | Processo elementar | Feature (N3) | Domínio | Tipo | ALR | DER | Complexidade | PF | Observação |
|---|---|---|---|---|---|---|---|---|---|
| 140 | Apurar Resultado da Etapa | [`AVL-APU-01` Apurar Resultado da Etapa](../modules/avaliacao/apuracao-devolutiva/f-apurar-resultado-etapa.md) | Avaliação | SE | 7 | 19 | Complexo | 7 | DER revisto em 2026-10-04 contra o resumo de entrega da SP06: entram a marca de desclassificada e a sua justificativa. Mesma faixa de 6 a 19 — PF inalterado |
| 141 | Registrar Desempate | [`AVL-APU-02` Registrar Desempate](../modules/avaliacao/apuracao-devolutiva/f-registrar-desempate.md) | Avaliação | EE | 3 | 8 | Complexo | 6 | — |
| 142 | Encerrar Etapa por UF | [`AVL-APU-03` Encerrar Etapa por UF](../modules/avaliacao/apuracao-devolutiva/f-encerrar-etapa-uf.md) | Avaliação | EE | 4 | 10 | Complexo | 6 | — |
| 143 | Revisar Devolutiva | [`AVL-APU-05` Revisar Devolutiva](../modules/avaliacao/apuracao-devolutiva/f-revisar-devolutiva.md) | Avaliação | EE | 3 | 6 | Complexo | 6 | — |
| 144 | Consultar Ranking da Etapa | [`AVL-APU-08` Consultar Ranking da Etapa](../modules/avaliacao/apuracao-devolutiva/f-consultar-ranking-etapa.md) | Avaliação | SE | 7 | 18 | Complexo | 7 | DER revisto em 2026-10-04 contra o resumo de entrega da SP06: entram o selo de desclassificada e a sua justificativa. Mesma faixa de 6 a 19 — PF inalterado |
| 145 | Exportar Relatório da Etapa | [`AVL-APU-09` Exportar Relatório da Etapa](../modules/avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md) | Avaliação | SE | 7 | 19 | Complexo | 7 | DER passou de 17 a 19 em 2026-10-02: `PDTIC25093-64` pede a colocação no ranking dentro do Relatório da Etapa, e a média final vinha junto na descrição sem estar enumerada. Mesma faixa de 6 a 19 — o PF não se move |
| 146 | Consultar Relatório de Inscrições | [`AVL-APU-10` Gerar Relatório de Inscrições](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md) | Avaliação | SE | 6 | 14 | Complexo | 7 | — |
| 147 | Exportar Relatório de Inscrições | [`AVL-APU-10` Gerar Relatório de Inscrições](../modules/avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md) | Avaliação | SE | 6 | 13 | Complexo | 7 | — |
| 148 | Reabrir Etapa por UF | [`AVL-APU-12` Reabrir Etapa por UF](../modules/avaliacao/apuracao-devolutiva/f-reabrir-etapa-uf.md) | Avaliação | EE | 3 | 4 | Médio | 4 | — |
| 149 | Exportar Relatório de Avaliadores | [`AVL-PAI-04` Exportar Relatório de Avaliadores](../modules/avaliacao/painel-administrativo/f-exportar-relatorio-avaliadores.md) | Avaliação | SE | 5 | 17 | Complexo | 7 | — |
| 150 | Exportar Histórico do Painel de Validação | [`VAL-FIL-03` Exportar Histórico do Painel de Validação](../modules/validacao/fila-validacao/f-exportar-historico-painel.md) | Validação | SE | 6 | 18 | Complexo | 7 | — |
| 151 | Editar Inscrição Validada | [`VAL-ANA-05` Editar Inscrição Validada](../modules/validacao/analise-decisao/f-editar-inscricao-validada.md) | Validação | EE | 3 | 11 | Complexo | 6 | — |

**Subtotal fora do baseline: 77 PF** (12 PE).

> **Duas classificações merecem conferência da métrica.** `Consultar Ranking da Etapa` foi classificado **SE** porque as duas linhas de corte e a Coleta são dados derivados; se a métrica os entender como recuperação, o PE é **CE** e vale 6 PF em vez de 7. E `Consultar Relatório de Inscrições` e `Exportar Relatório de Inscrições` contam como **dois PE** pela convenção destes sistemas para exportação — ver `global/SIZING.md` → *Funcionalidades iguais em formatos de saída diferentes*.

---

## 1C. Processos elementares contados fora do baseline (2026-10-02)

Os **2 processos elementares** pedidos em `PDTIC25093-65` (card de 2026-08-26, *Melhorias 25/08*) e que **não existem** na contagem de 2026-02-28 — a capacidade foi pedida seis meses depois de o baseline ser levantado. Até 2026-10-02 as duas features traziam a premissa "sem processo elementar correspondente", que descrevia a ausência na planilha sem dizer a causa; a análise de impacto do card identificou a origem e a contagem foi feita sobre os N3, pelas regras do IFPUG CPM 4.3.1 e pelas mesmas convenções de ALR do baseline. A memória de cálculo de cada um está no seu N3.

⚠️ **Pendente de validação pela equipe de métricas** — como os 77 PF da seção 1B. Enquanto não houver validação, estes 14 PF são contagem própria, não medida homologada.

| # | Processo elementar | Feature (N3) | Domínio | Tipo | ALR | DER | Complexidade | PF | Observação |
|---|---|---|---|---|---|---|---|---|---|
| 152 | Exportar Relatório de Alocação | [`AVL-ALO-07` Exportar Relatório de Alocação](../modules/avaliacao/alocacao/f-exportar-relatorio-alocacao.md) | Avaliação | SE | 7 | 16 | Complexo | 7 | Item 1 de `PDTIC25093-65`. Tratar as duas contagens de inscrições alocadas (por avaliador e por estado) como um DER só levaria a 8 DER, na mesma faixa de 6 a 19 — PF inalterado |
| 153 | Consultar Panorama do Avaliador | [`AVL-ALO-05` Consultar Panorama do Avaliador](../modules/avaliacao/alocacao/f-consultar-panorama-avaliador.md) | Avaliação | SE | 8 | 22 | Complexo | 7 | Item 2 de `PDTIC25093-65`. O diálogo abre a partir de duas telas de alocação (por grupo e por participante) e conta como **um** PE, porque a lógica de processamento é a mesma |

**Subtotal fora do baseline: 14 PF** (2 PE).

> **Uma classificação merece conferência da métrica.** Os dois PE foram classificados **SE** por entregarem dado derivado — os quatro totais do panorama e as cargas por avaliador e por estado do relatório são contagens, não recuperação. Se a métrica os entender como recuperação, cada um é **CE** e vale 6 PF em vez de 7, e o subtotal cai de 14 para 12.

---

## 1D. Processos elementares contados fora do baseline (2026-10-04)

Os **5 processos elementares** das duas funcionalidades que a **Sprint 6** entregou em 2026-10-01 e que não existiam no baseline de 2026-02-28 — nem na conferência com o código de 2026-08-28, porque ainda não tinham sido escritas. Contados sobre os N3 criados na mesma data, pelas regras do IFPUG CPM 4.3.1 e pelas convenções de ALR do baseline, com uma convenção nova: o **Disparo de Feedback** é subgrupo do ALI *Auditoria de E-mails*, não arquivo próprio.

⚠️ **Pendente de validação pela equipe de métricas** — como os 77 PF da seção 1B e os 14 PF da 1C.

| # | Processo elementar | Feature (N3) | Domínio | Tipo | ALR | DER | Complexidade | PF | Observação |
|---|---|---|---|---|---|---|---|---|---|
| 154 | Desclassificar Inscrição na Etapa | [`AVL-APU-13` Desclassificar Inscrição na Etapa](../modules/avaliacao/apuracao-devolutiva/f-desclassificar-inscricao-etapa.md) | Avaliação | EE | 4 | 8 | Complexo | 6 | Migração V00035. Grava a desclassificação com justificativa obrigatória de até 100 caracteres, responsável e data |
| 155 | Reverter Desclassificação da Inscrição | [`AVL-APU-13` Desclassificar Inscrição na Etapa](../modules/avaliacao/apuracao-devolutiva/f-desclassificar-inscricao-etapa.md) | Avaliação | EE | 3 | 6 | Complexo | 6 | A outra direção do mesmo estado binário, contada à parte por não receber justificativa e por apagar os três campos que a desclassificação grava. ⚠️ Se a métrica tratar a alternância como **um** PE, estes 6 PF saem |
| 156 | Consultar Envio de Feedback | [`AVL-APU-14` Enviar Feedback ao Participante](../modules/avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md) | Avaliação | SE | 4 | 12 | Complexo | 7 | Migração V00034. A prévia de quem receberá o aviso, com a situação de cada envio e o motivo do impedimento |
| 157 | Enviar Feedback da Etapa | [`AVL-APU-14` Enviar Feedback ao Participante](../modules/avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md) | Avaliação | EE | 5 | 10 | Complexo | 6 | Grava o registro do disparo e enfileira um aviso por participante |
| 158 | Reenfileirar Falhas de Envio | [`AVL-APU-14` Enviar Feedback ao Participante](../modules/avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md) | Avaliação | EE | 2 | 5 | Médio | 4 | Devolve à fila apenas os avisos cuja situação é falha |

**Subtotal fora do baseline: 29 PF** (5 PE).

> **Duas decisões merecem conferência da métrica.** **1)** A alternância da desclassificação foi contada como **dois** processos elementares, porque a lógica de processamento e os dados que atravessam a fronteira diferem entre as duas direções — diferente de `Ativar/Inativar Categoria`, em que as duas movem o mesmo campo com os mesmos dados. Como um PE só, o subtotal cai de 29 para **23 PF**. **2)** O **Disparo de Feedback** (`TB_DISPARO_FEEDBACK`) está registrado como subgrupo do ALI *Auditoria de E-mails*; como ALI próprio, seria RLR 1 × DER 11, Baixa, **+7 PF** em funções de dados, e o ALR de `Enviar Feedback da Etapa` e de `Consultar Envio de Feedback` subiria em 1 — sem mover a complexidade de nenhum dos dois.

---

## 2. Funções de Dados — ALI / AIE

As **12 funções de dados** do baseline. Espelho de `global/DATA-MODEL.md → ## ALIs`; os RLR são as tabelas físicas do grupo e os DER os atributos, contados uma vez por ALI.

| ALI / AIE | Domínio | Tipo | RLR | DER | Complexidade | PF |
|---|---|---|---|---|---|---|
| Premiação | Configuração da Premiação | ALI | 9 | 71 | Complexo | 15 |
| Categoria | Configuração da Premiação | ALI | 2 | 13 | Simples | 7 |
| Modalidade | Configuração da Premiação | ALI | 2 | 19 | Simples | 7 |
| Tipo de Participante | Configuração da Premiação | ALI | 12 | 89 | Complexo | 15 |
| Listas do Sistema | Configuração da Premiação | ALI | 2 | 14 | Simples | 7 |
| Usuário | Acesso e Gestão | ALI | 3 | 8 | Simples | 7 |
| Inscrição | Inscrição | ALI | 11 | 85 | Complexo | 15 |
| Notificação Participante | Inscrição | ALI | 1 | 13 | Simples | 7 |
| Validação Inscrição | Validação | ALI | 3 | 23 | Médio | 10 |
| Auditoria de E-mails | Validação | ALI | 2 | 20 | Médio | 10 |
| Avaliação de Inscrição | Avaliação | ALI | 3 | 38 | Médio | 10 |
| Alocação Avaliadores | Avaliação | ALI | 1 | 12 | Simples | 7 |

**Subtotal Funções de Dados: 117 PF** (12 ALI · 0 AIE — o baseline não registra AIE).

### Memória de cálculo — Funções de Dados

<details><summary>RLR e DER nomeados de cada função de dados</summary>

- **Premiação** — RLR (9): TB_PREMIACAO · TB_LINK_PUBLICO · TB_TERMO_ACEITE · TB_CONFIGURACAO_EMAIL_PREMIO · TB_ETAPA · TB_TERMO_CONFIDENCIALIDADE · TB_ACEITE_TERMO_CONFIDENCIALIDADE · TB_ARQUIVO · TB_DESEMPATE_CRITERIO.
  DER (71): CD_PREMIACAO (TB_PREMIACAO) · NM_PREMIACAO · DS_PREMIACAO · DT_INICIO · DT_FIM · DS_IMAGEM_BANNER · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · DS_REGULAMENTO_URL · CD_LINK_PUBLICO (TB_LINK_PUBLICO) · CD_TIPO_PARTICIPANTE · DS_TOKEN_UNICO · DS_URL_SLUG · DT_CRIACAO · DT_EXPIRACAO · CD_TIPO_PART_MOD_CAT · TB_TERMO_ACEITE (TB_LINK_PUBLICO) · CD_TERMO_ACEITE · NM_TITULO · DS_TEXTO_HTML · NR_VERSAO · FL_OBRIGATORIO · CD_CONFIGURACAO_EMAIL_PREMIO (TB_CONFIGURACAO_EMAIL_PREMIO) · DS_TIPO_EMAIL · DS_ASSUNTO · DS_CORPO_HTML · CD_ETAPA (TB_ETAPA) · CD_PREMIACAO · NM_ETAPA · NR_ORDEM · DT_INICIO · DT_FIM · DS_SITUACAO · FL_ATIVO · DT_LIBERACAO_FEEDBACK · CD_TERMO_CONFIDENCIALIDADE (TB_TERMO_CONFIDENCIALIDADE) · CD_PREMIACAO · NM_TITULO · DS_TIPO · DS_TEXTO_HTML · CD_ARQUIVO · CD_ACEITE_TERMO_CONFIDENCIALIDADE (TB_ACEITE_TERMO_CONFIDENCIALIDADE) · CD_USUARIO_AVALIADOR · NM_AVALIADOR · LG_AVALIADOR · DT_ACEITE · DS_IP_ORIGEM · FL_ATIVO · CD_DESEMPATE_CRITERIO (TB_DESEMPATE_CRITERIO) · CD_PREMIACAO · CD_QUESTAO_AVALIACAO · NR_ORDEM · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO.
- **Categoria** — RLR (2): TB_CATEGORIA · TB_PREMIACAO_CATEGORIA.
  DER (13): CD_CATEGORIA (TB_CATEGORIA) · CD_PREMIACAO · NM_CATEGORIA · DS_CATEGORIA · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_PREMIACAO_CATEGORIA (TB_PREMIACAO_CATEGORIA) · CD_PREMIACAO · CD_CATEGORIA · NR_ORDEM.
- **Modalidade** — RLR (2): TB_MODALIDADE · TB_MODALIDADE_CATEGORIA.
  DER (19): CD_MODALIDADE (TB_MODALIDADE) · CD_CATEGORIA · NM_MODALIDADE · DS_MODALIDADE · DS_REGULAMENTO_LINK · DT_INSCRICAO_INICIO · DT_INSCRICAO_FIM · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_MODALIDADE_CATEGORIA (TB_MODALIDADE_CATEGORIA) · CD_MODALIDADE · CD_PREMIACAO_CATEGORIA · DS_REGULAMENTO_LINK · DT_INSCRICAO_INICIO · DT_INSCRICAO_FIM · NR_ORDEM.
- **Tipo de Participante** — RLR (12): TB_TIPO_PARTICIPANTE · TB_FORMULARIO_DINAMICO · TB_FORMULARIO_CAMPO · TB_SECAO_FORMULARIO · TB_ENQUADRAMENTO · TB_TIPO_VINCULO_MEMBRO · TB_MEMBRO_EQUIPE_CONFIG · TB_ANEXO_CONFIGURACAO · TB_QUESTIONARIO · TB_QUESTAO_AVALIACAO · TB_QUESTAO_ALTERNATIVA · TB_BRANDING_Premiação.
  DER (89): CD_TIPO_PARTICIPANTE (TB_TIPO_PARTICIPANTE) · CD_MODALIDADE · NM_TIPO_PARTICIPANTE · FL_PERMITE_EQUIPE · QT_EQUIPE_MINIMO · QT_EQUIPE_MAXIMO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · DS_SLUG_URL · DS_TIPO_PARTICIPANTE · DS_ABRANGENCIA · CD_FORMULARIO_DINAMICO (TB_FORMULARIO_DINAMICO) · NM_FORMULARIO_DINAMICO · NR_VERSAO · DS_CONFIGURACAO_JSON · DS_TITULO · DS_FORMULARIO_DINAMICO · CD_FORMULARIO_CAMPO (TB_FORMULARIO_CAMPO) · CD_TIPO_CAMPO · NM_ROTULO · DS_FORMULARIO_CAMPO · FL_OBRIGATORIO · NR_COLUNA_GRID · NR_ORDEM · DS_CONFIGURACAO_JSON · ID_ETAPA · DS_PERSONALIZACAO_JSON · DS_PLACEHOLDER · DS_VALIDACAO_REGEX · NR_TAMANHO_MAXIMO · DS_OPCOES_JSON · DS_DICA_PREENCHIMENTO · CD_SECAO_FORMULARIO (TB_SECAO_FORMULARIO) · NM_SECAO_FORMULARIO · DS_SECAO_FORMULARIO · NR_ORDEM · FL_OBRIGATORIA · CD_ENQUADRAMENTO (TB_ENQUADRAMENTO) · NM_ENQUADRAMENTO · DS_DESCRICAO · CD_TIPO_VINCULO_MEMBRO (TB_TIPO_VINCULO_MEMBRO) · NM_TIPO_VINCULO_MEMBRO · NR_ORDEM · CD_MEMBRO_EQUIPE_CONFIG (TB_MEMBRO_EQUIPE_CONFIG) · NM_CAMPO_EXTRA · FL_OBRIGATORIO · CD_ANEXO_CONFIGURACAO (TB_ANEXO_CONFIGURACAO) · NM_ANEXO_CONFIGURACAO · DS_ANEXO_CONFIGURACAO · FL_OBRIGATORIO · DS_EXTENSAO_PERMITIDA · NR_TAMANHO_MAXIMO_MB · NR_ORDEM · CD_QUESTIONARIO (TB_QUESTIONARIO) · NM_QUESTIONARIO · DS_QUESTIONARIO · CD_QUESTAO_ALTERNATIVA (TB_QUESTAO_ALTERNATIVA) · DS_TEXTO · NR_ORDEM · CD_QUESTAO_AVALIACAO (TB_QUESTAO_AVALIACAO) · CD_TIPO_QUESTAO · DS_ENUNCIADO · NR_LIMITE_CARACTERES · NR_ORDEM · FL_OBRIGATORIO · VL_PESO_NOTA · DS_TITULO · DS_DESCRICAO · CD_BRANDING_PREMIO (TB_BRANDING_PREMIO) · CD_PREMIACAO · DS_LOGO_URL · DS_COR_PRIMARIA · DS_COR_SECUNDARIA · DS_COR_FUNDO · DS_BANNER_URL · DS_FAVICON_URL.
- **Listas do Sistema** — RLR (2): TB_LISTA_SISTEMA · TB_LISTA_SISTEMA_ITEM.
  DER (14): CD_LISTA_SISTEMA (TB_LISTA_SISTEMA) · ID_CODIGO · NM_LISTA_SISTEMA · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_LISTA_SISTEMA_ITEM (TB_LISTA_SISTEMA_ITEM) · CD_LISTA_SISTEMA · VL_ITEM · DS_TEXTO · NR_ORDEM · FL_ATIVO.
- **Usuário** — RLR (3): Usuário · UF Regionais · Entidades.
  DER (8): id · login · nome · email · perfilId · nomePerfil · sistemasIds · ativo · idEntidades · idUF.
- **Inscrição** — RLR (11): TB_INSCRICAO · TB_INSCRICAO_RESPOSTA · TB_INSCRICAO_RESPOSTA_QUESTAO · TB_INSCRICAO_DOCUMENTO · TB_ARQUIVO · TB_CONTEUDO_ARQUIVO · TB_DOWNLOAD_ARQUIVO · TB_ACEITE_PARTICIPANTE · TB_AUTOSAVE_LOG · TB_INSCRICAO_HISTORICO · TB_INSCRICAO_SNAPSHOT.
  DER (85): CD_INSCRICAO (TB_INSCRICAO) · CD_USUARIO · CD_PREMIACAO · CD_CATEGORIA · CD_MODALIDADE · CD_TIPO_PARTICIPANTE · DS_STATUS · DT_INICIO · DT_FINALIZACAO · NR_PERCENTUAL_PREENCHIM... (Percentual de Preenchimento) · DS_NUMERO_PROTOCOLO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_TIPO_PART_MOD_CAT · CD_ENQUADRAMENTO · CD_UF · VL_EMAIL · CD_INSCRICAO_RESPOSTA (TB_INSCRICAO_RESPOSTA) · CD_FORMULARIO_CAMPO · DS_VALOR_TEXTO · NR_VALOR_NUMERICO · DT_VALOR_DATA · FL_VALOR_BOOLEANO · DT_ULTIMA_ALTERACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_INSCRICAO_RESPOSTA_QUESTAO (TB_INSCRICAO_RESPOSTA_QUESTAO) · CD_QUESTAO_AVALIACAO · CD_QUESTAO_ALTERNATIVA · DS_RESPOSTA_TEXTO · DT_ULTIMA_ALTERACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_INSCRICAO_DOCUMENTO (TB_INSCRICAO_DOCUMENTO) · NM_ARQUIVO · DS_TIPO_MIME · NR_TAMANHO_BYTES · DT_UPLOAD · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_ANEXO_CONFIGURACAO · CD_ARQUIVO (TB_ARQUIVO) · NM_ARQUIVO · NM_MIME · NR_TAMANHO · FL_STORED · CD_ACEITE_PARTICIPANTE (TB_ACEITE_PARTICIPANTE) · CD_TERMO_ACEITE · FL_ACEITO · DT_ACEITE · DS_IP_ORIGEM · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_AUTOSAVE_LOG (TB_AUTOSAVE_LOG) · DS_JSON_SNAPSHOT · DT_AUTOSAVE · DS_IP_ORIGEM · CD_INSCRICAO_HISTORICO (TB_INSCRICAO_HISTORICO) · DS_STATUS_ANTERIOR · DS_STATUS_NOVO · CD_USUARIO_RESPONSAVEL · DT_ALTERACAO · DS_OBSERVACAO · FL_ATIVO · CD_SNAPSHOT (TB_INSCRICAO_SNAPSHOT) · DS_TIPO · NR_RODADA · DT_CAPTURA · DS_JSON_ESTADO · FL_ACEITO.
- **Notificação Participante** — RLR (1): TB_NOTIFICACAO_PARTICIPANTE.
  DER (13): CD_NOTIFICACAO_PARTICIPANTE · CD_INSCRICAO · CD_USUARIO · DS_TIPO · NM_TITULO · DS_MENSAGEM · FL_LIDA · DT_ENVIO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO.
- **Validação Inscrição** — RLR (3): TB_VALIDACAO_INSCRICAO · TB_INSCRICAO_HISTORICO · TB_AJUSTE_ITEM.
  DER (23): CD_VALIDACAO_INSCRICAO (TB_VALIDACAO_INSCRICAO) · CD_INSCRICAO · CD_USUARIO_VALIDADOR · DS_STATUS_VALIDACAO · DS_PARECER · DT_VALIDACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_INSCRICAO_HISTORICO (TB_INSCRICAO_HISTORICO) · DS_STATUS_ANTERIOR · DS_STATUS_NOVO · CD_USUARIO_RESPONSAVEL · DT_ALTERACAO · DS_OBSERVACAO · NM_USUARIO_RESPONSAVEL · CD_AJUSTE_ITEM (TB_AJUSTE_ITEM) · NR_SEQUENCIA · DS_TEXTO · FL_ATENDIDO · DT_ATENDIDO · NM_USUARIO_RESPONSAVEL.
- **Auditoria de E-mails** — RLR (2): TB_AUDITORIA_EMAIL · TB_ANEXO_AUDITORIA_EMAIL.
  DER (20): CD_AUDITORIA_EMAIL (TB_AUDITORIA_EMAIL) · VL_FROM · VL_TO · VL_CC · VL_BCC · VL_SUBJECT · VL_BODY · FL_HTML · TS_SOLICITACAO · TS_ENVIO · NM_LOGIN · STATUS · ERRO · CD_ANEXO_AUDITORIA_EMAIL (TB_ANEXO_AUDITORIA_EMAIL) · CD_AUDITORIA_EMAIL · VL_NAME · BL_DATA · VL_MIME_TYPE · VL_LENGTH · FL_INLINE.
- **Avaliação de Inscrição** — RLR (3): TB_ALOCACAO_AVALIADOR_PARTICIPANTE · TB_AVALIACAO_HISTORICO · TB_AVALIACAO_NOTA.
  DER (38): CD_ALOCACAO_AVALIADOR_PARTICIPANTE (TB_ALOCACAO_AVALIADOR_PARTICIPANTE) · CD_ETAPA · CD_INSCRICAO · CD_USUARIO_AVALIADOR · DS_SITUACAO · DS_STATUS_AVALIACAO · DT_INICIO · DT_FINALIZACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · NM_AVALIADOR · LG_AVALIADOR · DS_FEEDBACK_AVALIADOR · CD_AVALIACAO_HISTORICO (TB_AVALIACAO_HISTORICO) · CD_ALOCACAO_AVALIADOR_PARTICIPANTE · DS_STATUS_ANTERIOR · DS_STATUS_NOVO · CD_USUARIO_RESPONSAVEL · NM_USUARIO_RESPONSAVEL · DT_ALTERACAO · DS_OBSERVACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · CD_AVALIACAO_NOTA (TB_AVALIACAO_NOTA) · CD_ALOCACAO_AVALIADOR_PARTICIPANTE · CD_QUESTAO_AVALIACAO · NR_VALOR · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO.
- **Alocação Avaliadores** — RLR (1): TB_ALOCACAO_AVALIADOR_GRUPO.
  DER (12): CD_ALOCACAO_AVALIADOR_GRUPO · CD_ETAPA · CD_TIPO_PART_MOD_CAT · CD_USUARIO_AVALIADOR · DS_SITUACAO · CD_CRIADO_POR · DT_CRIADO_EM · CD_ATUALIZADO_POR · DT_ATUALIZADO_EM · FL_ATIVO · NM_AVALIADOR · LG_AVALIADOR.

</details>

---

## 3. Total do sistema

| Categoria | PF | Origem |
|---|---|---|
| Funções de Transação (EE/SE/CE) | 530 | baseline 2026-02-28 |
| Funções de Dados (ALI/AIE) | 117 | baseline 2026-02-28 |
| **Total do baseline** | **647** | 2026-02-28 |
| Processos elementares fora do baseline (seção 1B) | 77 | contados em 2026-09-01 ⚠️ |
| Processos elementares fora do baseline (seção 1C) | 14 | contados em 2026-10-02 ⚠️ |
| Processos elementares fora do baseline (seção 1D) | 29 | contados em 2026-10-04 ⚠️ |
| **Total não ajustado (PF) do sistema hoje** | **767** | — |

> **PF não ajustado** (FSM puro) — a CAIXA não adota VAF nem PF ajustado (ver `SIZING.md`).

Dos 530 PF de transação do baseline, **487 PF** estão atribuídos às 90 features que absorvem PE; os 43 PF restantes pertencem aos 12 PE sem feature correspondente, listados acima com o motivo. Somando os 77 PF da seção 1B, os 14 PF da seção 1C e os 29 PF da seção 1D, as features do catálogo passam a somar **607 PF** — é o total que o `modules/INDEX.md` espelha.

---

## Histórico de recontagens

| Data | Autor | O que mudou | Δ PF | Total |
|---|---|---|---|---|
| 2026-10-04 | Análise de impacto SP06 (docqui) | Seção 1D: contados os 5 PE das duas funcionalidades novas da Sprint 6 — `AVL-APU-13` Desclassificar Inscrição na Etapa (2 PE) e `AVL-APU-14` Enviar Feedback ao Participante (3 PE). O resumo de entrega da sprint também corrigiu enumerações já registradas, sem mover PF: `AVL-APU-01` (DER 17→19), `AVL-APU-08` (16→18), `AVL-APU-09` (17→19), `AVL-ALO-05` (14→22) e `AVL-ALO-07` (ALR 4→7, DER 9→16) | +29 | 767 |
| 2026-10-02 | Análise de impacto `PDTIC25093-65` (docqui) | Seção 1C: contados os 2 PE do card (`AVL-ALO-05` Consultar Panorama do Avaliador e `AVL-ALO-07` Exportar Relatório de Alocação), que nasceram sem número por serem posteriores ao baseline. `AVL-APU-09` Exportar Relatório da Etapa teve o DER corrigido de 17 para 19 por `PDTIC25093-64`, sem mover o PF | +14 | 738 |
| 2026-09-01 | Contagem fora do baseline (docqui) | Seção 1B: contados os 12 PE que a SP05 entregou e o baseline não cobria | +77 | 724 |
| 2026-09-01 | Carga do baseline (docqui) | Carga inicial: 139 PE e 12 funções de dados transcritos do baseline APF, com a memória de cálculo da planilha | — | 647 |

---

## Links
[SIZING.md](./SIZING.md) · [DATA-MODEL.md](./DATA-MODEL.md) · [MASTER.md](./MASTER.md) · [INDEX geral](../modules/INDEX.md)
