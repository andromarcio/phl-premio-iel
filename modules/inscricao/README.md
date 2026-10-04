<!-- docqui: 4.1.0 | prompt: PROMPT_1A | atualizado: 2026-10-04 -->
# Major Feature Set: Inscrição
> **Nível 1** - Visão estratégica do domínio - `INS`

## Descrição
Responde por toda a jornada de inscrição do participante, do acesso pelo link público à finalização, sendo a fonte única das inscrições e do seu andamento. Mantém as respostas ao formulário e ao questionário, os documentos anexados, a composição da equipe, os aceites de termos e o histórico de cada inscrição. É consumido por Validação e Avaliação, que conferem e avaliam as inscrições enviadas, e pelo próprio participante, que acompanha o status e recebe a devolutiva.

### O que este domínio NÃO faz
| Descrição | Pertence a |
|---|---|
| Definir a estrutura, o formulário e os termos da inscrição | Configuração da Premiação |
| Conferir e aprovar/rejeitar a inscrição | Validação |
| Avaliar o projeto inscrito e apurar notas | Avaliação |
| Autenticar o participante (login) | Acesso e Gestão / SSO |

---

## Feature Sets

| Feature Set | Descrição | Features |
|---|---|---|
| [**Inscrição do Participante**](./inscricao-participante/README.md) <small>INS-PAR</small> | Realizar, salvar, editar, finalizar e reenviar a inscrição: formulário dinâmico, questionário, anexos, equipe e aceite de termos | 8 |
| [**Acompanhamento**](./acompanhamento/README.md) <small>INS-ACO</small> | Painel do participante com o status da inscrição, pendências e devolutiva | 2 |
| [**Notificações**](./notificacoes/README.md) <small>INS-NOT</small> | Avisos ao participante sobre o andamento da inscrição (in-app) | 2 |

---

## Regras transversais de negócio

1. Uma inscrição pertence a um participante e a uma oferta (tipo de participante × modalidade × categoria) de uma edição.
2. O trabalho do participante nunca é perdido — há rascunho autossalvo e a inscrição pode ser salva e retomada.
3. A inscrição só é submetida quando os itens obrigatórios (campos, anexos e termos) estão completos.
4. Toda mudança de status da inscrição é registrada no histórico.
5. A inscrição ocorre apenas na etapa regional; classificados avançam à etapa nacional sem nova inscrição.
6. Cada participante possui um número de protocolo único da inscrição.

---

## Integrações com outros domínios

### Leitura — domínios que consomem dados deste domínio
| Domínio | O que consome | Como |
|---|---|---|
| Validação | Inscrições enviadas, respostas, documentos e termos, para conferência | a confirmar no PROMPT_1B |
| Avaliação | Inscrições aprovadas na validação, para avaliação | a confirmar no PROMPT_1B |

### Escrita — domínios que criam ou alteram dados deste domínio
| Domínio | O que altera | Situação |
|---|---|---|
| Configuração da Premiação | Estrutura que a inscrição preenche (formulário, oferta, termos) | Ao montar/alterar a edição |
| Validação | Status da inscrição (em validação, aprovada, rejeitada, ajuste solicitado) e itens de ajuste | Na decisão de validação |
| Avaliação | Status de aprovação/classificação por etapa e devolutiva liberada | No fechamento da avaliação |

---

<div class="dev-only">

## Entidades do domínio

> Campos completos no data-model — ver `global/data-models/inscricao.md`.

| Entidade | Descrição | Campos no DATA-MODEL.md |
|---|---|---|
| Inscrição | Inscrição do participante e seu andamento | → ver DATA-MODEL.md: Inscrição |
| Notificação Participante | Avisos in-app ao participante | → ver DATA-MODEL.md: Notificação Participante |

> **ALIs deste domínio** (2, + infra de Arquivo): Inscrição · Notificação Participante — 22 PF (baseline APF). Ver `global/data-models/inscricao.md`.

</div>

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0: carimbo, título `# Major Feature Set:`, contagem de features por Feature Set conferida com os N3 existentes (inscricao-participante 7→8) e rodapé com os links dos Feature Sets. Seções técnicas do 1B (dependências externas, regras de acesso consolidadas) seguem fora do escopo do perfil `requisitos` |
| 2026-08-25 | Engenharia reversa (docqui) | N1 negocial criado | Domínio derivado do N0, das HUs e do data-model |

---

*Última revisão: 2026-10-04*

*Links: [Inscrição do Participante](./inscricao-participante/README.md) `INS-PAR` · [Acompanhamento](./acompanhamento/README.md) `INS-ACO` · [Notificações](./notificacoes/README.md) `INS-NOT` · [INDEX geral](../INDEX.md)*
