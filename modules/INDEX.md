# Índice geral de módulos
> Visão consolidada de todos os domínios do sistema.
> Mantido via PROMPT 1A/1B — atualizar após cada N1 aprovado.

---

## Domínios

| Domínio | Pasta | Responsabilidade | Feature Sets |
|---|---|---|---|
| [Configuração da Premiação](./configuracao/README.md) `CFG` | `modules/configuracao/` | Monta e parametriza a edição: estrutura, formulários, questionários, etapas, e-mails e critérios | 7 |
| [Inscrição](./inscricao/README.md) `INS` | `modules/inscricao/` | Jornada de inscrição do participante: preenchimento, anexos, equipe, acompanhamento e notificações | 3 |
| [Validação](./validacao/README.md) `VAL` | `modules/validacao/` | Conferência e decisão sobre inscrições por UF, com solicitação de ajustes auditada | 3 |
| [Avaliação](./avaliacao/README.md) `AVL` | `modules/avaliacao/` | Alocação de avaliadores, notas e pareceres, apuração, desempate e devolutiva | 5 |
| [Acesso e Gestão](./acesso/README.md) `ACS` | `modules/acesso/` | Acesso por perfil (login corporativo), administradores regionais e auditoria | 3 |

**5 domínios · 21 Feature Sets · 128 features** — data-model em `global/DATA-MODEL.md` (62 entidades, 12 ALIs, 117 PF).

> ✅ **Conferência com o código-fonte em 2026-08-28** — rotas, modelo de dados, enums, stack e regras de negócio foram confrontados com o backend e o frontend reais. O laudo completo, com o que foi corrigido e o que segue pendente de decisão, está em [`global/CONFORMIDADE-CODIGO.md`](../global/CONFORMIDADE-CODIGO.md). As **15 features** derivadas das capacidades que estavam implementadas sem especificação foram criadas na mesma data (`ACS-ACE-03`, `AVL-ALO-05..07`, `AVL-APU-08..10`, `AVL-AVA-06..07`, `AVL-PAI-04`, `CFG-PRE-13`, `INS-PAR-08`, `VAL-AJU-04`, `VAL-ANA-05..06`) e **ainda não têm contagem APF** — o baseline não as cobre.

---

## Rastreabilidade: ticket → spec → código

| Ticket (AIM) | Feature | Domínio | Status | Contagem | PF | CFP | Processo elementar (baseline APF) | Repositórios |
|---|---|---|---|---|---|---|---|---|
| — | [ACS-ACE-01: Autenticar Usuário](./acesso/acesso-perfis/f-autenticar-usuario.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | — | — | — *(LOGON não contado)* | — |
| — | [ACS-ACE-02: Consultar Perfil do Usuário](./acesso/acesso-perfis/f-consultar-perfil-usuario.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| — | [ACS-ACE-03: Vincular Usuário ao Sistema](./acesso/acesso-perfis/f-vincular-usuario-sistema.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| `HU-020_Cadastrar_Admin_Regionais` | [ACS-ADM-01: Pesquisar Administradores](./acesso/administradores-regionais/f-pesquisar-administrador.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | 3 | — | Pesquisar Usuários | — |
| `HU-020_Cadastrar_Admin_Regionais` | [ACS-ADM-02: Cadastrar Administrador Regional](./acesso/administradores-regionais/f-cadastrar-administrador-regional.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | 3 | — | Incluir Usuário | — |
| `HU-020_Cadastrar_Admin_Regionais` | [ACS-ADM-03: Editar Administrador Regional](./acesso/administradores-regionais/f-editar-administrador-regional.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | 6 | — | Editar Usuário (+1) | — |
| `HU-020_Cadastrar_Admin_Regionais` | [ACS-ADM-04: Vincular UF ao Administrador](./acesso/administradores-regionais/f-vincular-uf-administrador.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | — | — | — *(passo de outra feature)* | — |
| — | [ACS-AUD-01: Consultar Trilha de Auditoria](./acesso/auditoria/f-consultar-trilha-auditoria.md) | Acesso e Gestão | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️ · **não implementada** — `TL_LOG_AUDITORIA` nunca é gravada)* | — |
| `HU-025_Alocar_Avaliadores` | [AVL-ALO-01: Consultar Alocação de Avaliadores](./avaliacao/alocacao/f-consultar-alocacao-avaliadores.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Consultar Alocação de Avaliadores | — |
| `HU-025_Alocar_Avaliadores` | [AVL-ALO-02: Alocar Avaliador ao Grupo](./avaliacao/alocacao/f-alocar-avaliador-grupo.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Salvar Pool | — |
| `HU-025_Alocar_Avaliadores` | [AVL-ALO-03: Cadastrar Avaliador](./avaliacao/alocacao/f-cadastrar-avaliador.md) | Avaliação | ✏️ Rascunho | 📋 | 4 | — | Cadastrar Avaliador | — |
| [`PDTIC25093-60`](../analise-impacto/AIM-PDTIC25093-60.md) · `HU-025_Alocar_Avaliadores` | [AVL-ALO-04: Alocar Avaliador à Inscrição](./avaliacao/alocacao/f-alocar-avaliador-inscricao.md) | Avaliação | ✏️ Rascunho | 📋 | 17 | — | Incluir Avaliadores para Inscrição (+2) | — |
| [`PDTIC25093-65`](../analise-impacto/AIM-PDTIC25093-65.md) | [AVL-ALO-05: Consultar Panorama do Avaliador](./avaliacao/alocacao/f-consultar-panorama-avaliador.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Consultar Panorama do Avaliador | — |
| — | [AVL-ALO-06: Consultar Pendências de Alocação](./avaliacao/alocacao/f-consultar-pendencias-alocacao.md) | Avaliação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| [`PDTIC25093-65`](../analise-impacto/AIM-PDTIC25093-65.md) | [AVL-ALO-07: Exportar Relatório de Alocação](./avaliacao/alocacao/f-exportar-relatorio-alocacao.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Exportar Relatório de Alocação | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) | [AVL-APU-01: Apurar Resultado da Etapa](./avaliacao/apuracao-devolutiva/f-apurar-resultado-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Apurar Resultado da Etapa | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) | [AVL-APU-02: Registrar Desempate](./avaliacao/apuracao-devolutiva/f-registrar-desempate.md) | Avaliação | ✏️ Rascunho | 📋 | 6 | — | Registrar Desempate | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) | [AVL-APU-03: Encerrar Etapa por UF](./avaliacao/apuracao-devolutiva/f-encerrar-etapa-uf.md) | Avaliação | ✏️ Rascunho | 📋 | 6 | — | Encerrar Etapa por UF | — |
| `HU-031_Consolidar_Feedback` | [AVL-APU-04: Gerar Devolutiva com IA](./avaliacao/apuracao-devolutiva/f-gerar-devolutiva-ia.md) | Avaliação | ✏️ Rascunho | 📋 | 4 | — | Gerar com IA | — |
| `HU-031_Consolidar_Feedback` | [AVL-APU-05: Revisar Devolutiva](./avaliacao/apuracao-devolutiva/f-revisar-devolutiva.md) | Avaliação | ✏️ Rascunho | 📋 | 6 | — | Revisar Devolutiva | — |
| [`PDTIC25093-56`](../analise-impacto/AIM-PDTIC25093-56.md) · `HU-037_Relatorio_Inscricoes_Em_Andamento` | [AVL-APU-06: Gerar Relatório de Inscrições Paradas](./avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md) | Avaliação | ✏️ Rascunho | 📋 | 14 | — | Relatório de Inscrições Paradas (+1) | — |
| [`PDTIC25093-66`](../analise-impacto/AIM-PDTIC25093-66.md) | [AVL-APU-08: Consultar Ranking da Etapa](./avaliacao/apuracao-devolutiva/f-consultar-ranking-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Consultar Ranking da Etapa | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) | [AVL-APU-09: Exportar Relatório da Etapa](./avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Exportar Relatório da Etapa | — |
| [`PDTIC25093-64`](../analise-impacto/AIM-PDTIC25093-64.md) | [AVL-APU-09: Exportar Relatório da Etapa](./avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Exportar Relatório da Etapa | — |
| [`PDTIC25093-56`](../analise-impacto/AIM-PDTIC25093-56.md) | [AVL-APU-10: Gerar Relatório de Inscrições](./avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md) | Avaliação | ✏️ Rascunho | 📋 | 14 | — | Consultar Relatório de Inscrições (+1) | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) · `HU-030_Fechar_Etapa_Avaliacao` | [AVL-APU-12: Reabrir Etapa por UF](./avaliacao/apuracao-devolutiva/f-reabrir-etapa-uf.md) | Avaliação | ✏️ Rascunho | 📋 | 4 | — | Reabrir Etapa por UF | — |
| — | [AVL-APU-13: Desclassificar Inscrição na Etapa](./avaliacao/apuracao-devolutiva/f-desclassificar-inscricao-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 12 | — | Desclassificar Inscrição na Etapa (+1) | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) | [AVL-APU-14: Enviar Feedback ao Participante](./avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md) | Avaliação | ✏️ Rascunho | 📋 | 17 | — | Consultar Envio de Feedback (+2) | — |
| [`PDTIC25093-61`](../analise-impacto/AIM-PDTIC25093-61.md) · `HU-033_Painel_Avaliacao_Avaliador` | [AVL-AVA-01: Acompanhar Minhas Avaliações](./avaliacao/avaliacao-projetos/f-acompanhar-minhas-avaliacoes.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Consultar Painel Minhas Avaliações | — |
| `HU-029_Termo_Confidencialidade_Avaliador` | [AVL-AVA-02: Aceitar Termo de Confidencialidade](./avaliacao/avaliacao-projetos/f-aceitar-termo-confidencialidade.md) | Avaliação | ✏️ Rascunho | 📋 | 9 | — | Aceitar Termo de Aceite (+2) | — |
| [`PDTIC25093-61`](../analise-impacto/AIM-PDTIC25093-61.md) · `HU-028_Avaliar_Inscricao` | [AVL-AVA-03: Avaliar Inscrição](./avaliacao/avaliacao-projetos/f-avaliar-inscricao.md) | Avaliação | ✏️ Rascunho | 📋 | 10 | — | Salvar Avaliação (+1) | — |
| [`PDTIC25093-61`](../analise-impacto/AIM-PDTIC25093-61.md) · `HU-028_Avaliar_Inscricao` | [AVL-AVA-04: Finalizar Avaliação](./avaliacao/avaliacao-projetos/f-finalizar-avaliacao.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Finalizar Avaliação | — |
| `HU-025_Alocar_Avaliadores` | [AVL-AVA-05: Reabrir Avaliação](./avaliacao/avaliacao-projetos/f-reabrir-avaliacao.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Reabrir Avaliação | — |
| `HU-028_Avaliar_Inscricao` | [AVL-AVA-06: Consultar Outros Avaliadores](./avaliacao/avaliacao-projetos/f-consultar-outros-avaliadores.md) | Avaliação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| `HU-029_Termo_Confidencialidade_Avaliador` | [AVL-AVA-07: Consultar Premiações do Avaliador](./avaliacao/avaliacao-projetos/f-consultar-premiacoes-avaliador.md) | Avaliação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| `HU-024_Configurar_Etapas_de_Avaliacao` | [AVL-ETA-01: Configurar Avaliação](./avaliacao/etapas-configuracao/f-configurar-avaliacao.md) | Avaliação | ✏️ Rascunho | 📋 | 8 | — | Alterar Configurações Avaliações e Etapas (+1) | — |
| [`PDTIC25093-67`](../analise-impacto/AIM-PDTIC25093-67.md) · `HU-024_Configurar_Etapas_de_Avaliacao` | [AVL-ETA-02: Cadastrar Etapa](./avaliacao/etapas-configuracao/f-cadastrar-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Cadastrar Nova Etapa | — |
| [`PDTIC25093-67`](../analise-impacto/AIM-PDTIC25093-67.md) · `HU-024_Configurar_Etapas_de_Avaliacao` | [AVL-ETA-03: Editar Etapa](./avaliacao/etapas-configuracao/f-editar-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Editar Etapa (+1) | — |
| `HU-024_Configurar_Etapas_de_Avaliacao` | [AVL-ETA-04: Excluir Etapa](./avaliacao/etapas-configuracao/f-excluir-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Excluir Etapa | — |
| `HU-024_Configurar_Etapas_de_Avaliacao` | [AVL-ETA-05: Reordenar Etapas](./avaliacao/etapas-configuracao/f-reordenar-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 3 | — | Alterar ordem das etapas | — |
| `HU-032_Configurar_Criterios_de_Desempate` | [AVL-ETA-06: Configurar Critérios de Desempate](./avaliacao/etapas-configuracao/f-configurar-criterios-desempate.md) | Avaliação | ✏️ Rascunho | 📋 | 6 | — | Configurar Critérios de Desempate (+1) | — |
| `HU-029_Termo_Confidencialidade_Avaliador` | [AVL-ETA-07: Configurar Termo de Confidencialidade](./avaliacao/etapas-configuracao/f-configurar-termo-confidencialidade.md) | Avaliação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| [`PDTIC25093-65`](../analise-impacto/AIM-PDTIC25093-65.md) · `HU-027_Painel_Administrativo_Avaliacoes` | [AVL-PAI-01: Acompanhar Painel de Avaliações](./avaliacao/painel-administrativo/f-acompanhar-painel-avaliacoes.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Consultar Painel de Avaliações | — |
| `HU-027_Painel_Administrativo_Avaliacoes` | [AVL-PAI-02: Consultar Avaliações por Etapa](./avaliacao/painel-administrativo/f-consultar-avaliacoes-etapa.md) | Avaliação | ✏️ Rascunho | 📋 | 11 | — | Consultar Avaliações por Etapa (+1) | — |
| [`PDTIC25093-49`](../analise-impacto/AIM-PDTIC25093-49.md) · `HU-027_Painel_Administrativo_Avaliacoes` · `HU-031_Consolidar_Feedback` | [AVL-PAI-03: Consolidar Avaliação](./avaliacao/painel-administrativo/f-consolidar-avaliacao.md) | Avaliação | ✏️ Rascunho | 📋 | 6 | — | Consolidar Avaliação (+1) | — |
| — | [AVL-PAI-04: Exportar Relatório de Avaliadores](./avaliacao/painel-administrativo/f-exportar-relatorio-avaliadores.md) | Avaliação | ✏️ Rascunho | 📋 | 7 | — | Exportar Relatório de Avaliadores | — |
| `HU-004_Cadastrar_Categorias` | [CFG-CAT-01: Pesquisar Categorias](./configuracao/categorias/f-pesquisar-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 5 | — | Pesquisar Categorias | — |
| `HU-004_Cadastrar_Categorias` | [CFG-CAT-02: Cadastrar Categoria](./configuracao/categorias/f-cadastrar-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Incluir Categoria | — |
| `HU-004_Cadastrar_Categorias` | [CFG-CAT-03: Editar Categoria](./configuracao/categorias/f-editar-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 8 | — | Editar Categoria (+1) | — |
| `HU-004_Cadastrar_Categorias` | [CFG-CAT-04: Visualizar Categoria](./configuracao/categorias/f-visualizar-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 0 ⚠️ | — | Detalhar Categoria | — |
| `HU-004_Cadastrar_Categorias` | [CFG-CAT-05: Ativar/Inativar Categoria](./configuracao/categorias/f-ativar-inativar-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Ativar/Inativar Categoria | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) · `HU-021_Configurar_Templates_Email` | [CFG-EMA-01: Consultar Modelos de E-mail](./configuracao/modelos-email/f-consultar-modelo-email.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Consultar Template de E-mail (implícita) | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) · `HU-021_Configurar_Templates_Email` | [CFG-EMA-02: Editar Modelo de E-mail](./configuracao/modelos-email/f-editar-modelo-email.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Editar Template de E-mail | — |
| `HU-021_Configurar_Templates_Email` | [CFG-EMA-03: Visualizar E-mail](./configuracao/modelos-email/f-visualizar-email.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Visualizar E-mail | — |
| `HU-012_Listas_do_Sistema` | [CFG-LIS-01: Pesquisar Listas](./configuracao/listas-sistema/f-pesquisar-lista.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Pesquisar Listas do Sistema | — |
| `HU-012_Listas_do_Sistema` | [CFG-LIS-02: Cadastrar Lista](./configuracao/listas-sistema/f-cadastrar-lista.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Incluir Lista do Sistema | — |
| `HU-012_Listas_do_Sistema` | [CFG-LIS-03: Editar Lista](./configuracao/listas-sistema/f-editar-lista.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Editar Lista do Sistema (+1) | — |
| `HU-012_Listas_do_Sistema` | [CFG-LIS-04: Excluir Lista](./configuracao/listas-sistema/f-excluir-lista.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Excluir Lista do Sistema | — |
| `HU-012_Listas_do_Sistema` | [CFG-LIS-05: Configurar Itens da Lista](./configuracao/listas-sistema/f-configurar-itens-lista.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Ordenar Lista | — |
| `HU-005_Cadastrar_Modalidades` | [CFG-MOD-01: Pesquisar Modalidades](./configuracao/modalidades/f-pesquisar-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 4 | — | Pesquisar Modalidade | — |
| `HU-005_Cadastrar_Modalidades` | [CFG-MOD-02: Cadastrar Modalidade](./configuracao/modalidades/f-cadastrar-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Incluir Modalidade | — |
| `HU-005_Cadastrar_Modalidades` | [CFG-MOD-03: Editar Modalidade](./configuracao/modalidades/f-editar-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 8 | — | Editar Modalidade (+1) | — |
| `HU-005_Cadastrar_Modalidades` | [CFG-MOD-04: Visualizar Modalidade](./configuracao/modalidades/f-visualizar-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 0 ⚠️ | — | Detalhar Modalidade | — |
| `HU-005_Cadastrar_Modalidades` | [CFG-MOD-05: Ativar/Inativar Modalidade](./configuracao/modalidades/f-ativar-inativar-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Ativar/Inativar Modalidade | — |
| `HU-001_Gerenciar_Premios` | [CFG-PRE-01: Pesquisar Prêmios](./configuracao/premios/f-pesquisar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 4 | — | Pesquisar Premiações | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-02: Cadastrar Prêmio](./configuracao/premios/f-cadastrar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Incluir Prêmio | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-03: Editar Prêmio](./configuracao/premios/f-editar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-001_Gerenciar_Premios` | [CFG-PRE-04: Ativar/Inativar Prêmio](./configuracao/premios/f-ativar-inativar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-003_Exportar_Premios` · `HU-001_Gerenciar_Premios` | [CFG-PRE-05: Exportar Prêmios](./configuracao/premios/f-exportar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-003_Exportar_Premios` | [CFG-PRE-06: Importar Prêmios](./configuracao/premios/f-importar-premio.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-07: Gerar Link Público](./configuracao/premios/f-gerar-link-publico.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Gerar Novo Link | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-08: Consultar Links Públicos](./configuracao/premios/f-consultar-link-publico.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Consultar Links Públicos de Inscrição | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-09: Cadastrar Termo de Aceite](./configuracao/premios/f-cadastrar-termo-aceite.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Incluir Termo de Aceite (+1) | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-10: Editar Termo de Aceite](./configuracao/premios/f-editar-termo-aceite.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Editar Termo de Aceite (+1) | — |
| `HU-002_Cadastrar_Premios` | [CFG-PRE-11: Excluir Termo de Aceite](./configuracao/premios/f-excluir-termo-aceite.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Excluir Termo de Aceite | — |
| — | [CFG-PRE-12: Configurar Critérios de Avaliação](./configuracao/premios/f-configurar-criterios-avaliacao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️ · **não implementada** — sem controller nem tela)* | — |
| — | [CFG-PRE-13: Carregar Imagem de Configuração](./configuracao/premios/f-carregar-imagem-configuracao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️ · sem tela que a consuma)* | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-01: Pesquisar Tipos de Participante](./configuracao/tipos-participante/f-pesquisar-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 4 | — | Pesquisar Tipo de Participante | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-02: Cadastrar Tipo de Participante](./configuracao/tipos-participante/f-cadastrar-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Incluir Tipo de Participante | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-03: Editar Tipo de Participante](./configuracao/tipos-participante/f-editar-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 10 | — | Editar Tipo de Participante (+1) | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-04: Visualizar Tipo de Participante](./configuracao/tipos-participante/f-visualizar-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 0 ⚠️ | — | Detalhar Tipo de Participante | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-05: Ativar/Inativar Tipo de Participante](./configuracao/tipos-participante/f-ativar-inativar-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Ativar/Inativar Tipo de Participante | — |
| `HU-007_Configurar_Formulario_Tipo_Participante` | [CFG-TIP-06: Configurar Formulário de Inscrição](./configuracao/tipos-participante/f-configurar-formulario.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 9 | — | Configurar Estrutura do Formulário de Inscrição (+1) | — |
| `HU-007_Configurar_Formulario_Tipo_Participante` | [CFG-TIP-07: Cadastrar Campo](./configuracao/tipos-participante/f-cadastrar-campo.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 4 | — | Adicionar Campo | — |
| `HU-007_Configurar_Formulario_Tipo_Participante` | [CFG-TIP-08: Editar Campo](./configuracao/tipos-participante/f-editar-campo.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 10 | — | Editar Campo (+1) | — |
| `HU-007_Configurar_Formulario_Tipo_Participante` | [CFG-TIP-09: Excluir Campo](./configuracao/tipos-participante/f-excluir-campo.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Excluir Campo | — |
| `HU-008_Enquadramento_Tipo_Participante` | [CFG-TIP-10: Cadastrar Enquadramento](./configuracao/tipos-participante/f-cadastrar-enquadramento.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-008_Enquadramento_Tipo_Participante` | [CFG-TIP-11: Ativar/Inativar Enquadramento](./configuracao/tipos-participante/f-ativar-inativar-enquadramento.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| `HU-009_Anexo_Tipo_Participante` | [CFG-TIP-12: Configurar Anexos Exigidos](./configuracao/tipos-participante/f-configurar-anexo.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 21 | — | Listar Configuração de Anexos (+4) | — |
| `HU-010_Questoes_Tipo_Participante` | [CFG-TIP-13: Cadastrar Questão](./configuracao/tipos-participante/f-cadastrar-questao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 9 | — | Incluir Questão do Questionário Avaliação (+1) | — |
| `HU-010_Questoes_Tipo_Participante` | [CFG-TIP-14: Editar Questão](./configuracao/tipos-participante/f-editar-questao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 9 | — | Editar Questão do Questionário Avaliação (+1) | — |
| `HU-006_Cadastrar_Tipo_Participantes` | [CFG-TIP-15: Configurar Equipe](./configuracao/tipos-participante/f-configurar-equipe.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 17 | — | Listar Configuração de Equipe (+4) | — |
| — | [CFG-TIP-16: Importar Configuração do Tipo de Participante](./configuracao/tipos-participante/f-importar-configuracao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Importar Configuração Excel | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-01: Consultar Estrutura da Premiação](./configuracao/ofertas/f-consultar-estrutura-premiacao.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Consultar Categorias (lista/pesquisa) (+1) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-02: Vincular Categoria](./configuracao/ofertas/f-vincular-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 6 | — | Criar e Vincular Categoria (+1) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-03: Desvincular Categoria](./configuracao/ofertas/f-desvincular-categoria.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Desvincular Categoria | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-04: Vincular Modalidade](./configuracao/ofertas/f-vincular-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 7 | — | Criar e Vincular Modalidade (+1) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-05: Desvincular Modalidade](./configuracao/ofertas/f-desvincular-modalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Desvincular Modalidade | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-06: Vincular Tipo de Participante](./configuracao/ofertas/f-vincular-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 4 | — | Copiar Tipo de Participante | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-07: Desvincular Tipo de Participante](./configuracao/ofertas/f-desvincular-tipo-participante.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Desvincular Tipo de Participante | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` · `HU-004_Cadastrar_Categorias` | [CFG-VIN-08: Duplicar Oferta](./configuracao/ofertas/f-duplicar-oferta.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 12 | — | Duplicar Categoria (+2) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-09: Cadastrar Submodalidade](./configuracao/ofertas/f-cadastrar-submodalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 7 | — | Incluir Submodalidades (+1) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-10: Editar Submodalidade](./configuracao/ofertas/f-editar-submodalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 7 | — | Editar Submodalidade (+1) | — |
| `HU-011_Vincular_Categoria_Modalidade_TipoParticipante` | [CFG-VIN-11: Ativar/Inativar Submodalidade](./configuracao/ofertas/f-ativar-inativar-submodalidade.md) | Configuração da Premiação | ✏️ Rascunho | 📋 | 3 | — | Ativar/Desativar Submodalidade | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) · `HU-016_Dashboard_Participante` | [INS-ACO-01: Acompanhar Inscrição](./inscricao/acompanhamento/f-acompanhar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | 7 | — | Consultar Dashboard do Participante | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) · `HU-031_Consolidar_Feedback` | [INS-ACO-02: Visualizar Devolutiva](./inscricao/acompanhamento/f-visualizar-devolutiva.md) | Inscrição | ✏️ Rascunho | 📋 | — | — | — *(sem PE ⚠️)* | — |
| [`PDTIC25093-69`](../analise-impacto/AIM-PDTIC25093-69.md) · `HU-022_Notificacoes_InApp` | [INS-NOT-01: Consultar Notificações](./inscricao/notificacoes/f-consultar-notificacao.md) | Inscrição | ✏️ Rascunho | 📋 | 4 | — | Consultar Notificações | — |
| `HU-022_Notificacoes_InApp` | [INS-NOT-02: Marcar Notificação como Lida](./inscricao/notificacoes/f-marcar-notificacao-lida.md) | Inscrição | ✏️ Rascunho | 📋 | 3 | — | Marcar Notificação como Lida | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-01: Cadastrar Inscrição](./inscricao/inscricao-participante/f-cadastrar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | 6 | — | Realizar Inscrição (Rascunho) | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-02: Editar Inscrição](./inscricao/inscricao-participante/f-editar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | 6 | — | Editar Inscrição | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-03: Finalizar Inscrição](./inscricao/inscricao-participante/f-finalizar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | 3 | — | Finalizar Inscrição | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-04: Reenviar Inscrição](./inscricao/inscricao-participante/f-reenviar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | 3 | — | Reenviar Inscrição (+1) | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-05: Anexar Documento](./inscricao/inscricao-participante/f-anexar-documento.md) | Inscrição | ✏️ Rascunho | 📋 | — | — | — *(passo de outra feature)* | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-06: Aceitar Termo](./inscricao/inscricao-participante/f-aceitar-termo.md) | Inscrição | ✏️ Rascunho | 📋 | 3 | — | Consultar Termo de Aceite | — |
| `HU-015_Inscricao_Participante` · `HU-016_Dashboard_Participante` | [INS-PAR-07: Retomar Inscrição](./inscricao/inscricao-participante/f-retomar-inscricao.md) | Inscrição | ✏️ Rascunho | 📋 | — | — | — *(passo de outra feature)* | — |
| `HU-015_Inscricao_Participante` | [INS-PAR-08: Registrar Pré-cadastro](./inscricao/inscricao-participante/f-registrar-pre-cadastro.md) | Inscrição | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| `HU-019_Solicitar_Ajustes_Inscricao` | [VAL-AJU-01: Solicitar Ajuste](./validacao/ajustes/f-solicitar-ajuste.md) | Validação | ✏️ Rascunho | 📋 | 6 | — | Solicitar Ajuste | — |
| `HU-026_Auditoria_Ajustes_Inscricao` · `HU-019_Solicitar_Ajustes_Inscricao` | [VAL-AJU-02: Consultar Auditoria de Ajustes](./validacao/ajustes/f-consultar-auditoria-ajustes.md) | Validação | ✏️ Rascunho | 📋 | 5 | — | Consultar Auditoria de Ajustes | — |
| `HU-026_Auditoria_Ajustes_Inscricao` | [VAL-AJU-03: Exportar Auditoria de Ajustes](./validacao/ajustes/f-exportar-auditoria-ajustes.md) | Validação | ✏️ Rascunho | 📋 | 4 | — | Exportar Auditoria de Ajustes para CSV | — |
| `HU-018_Analisar_Validar_Inscricao` · `HU-019_Solicitar_Ajustes_Inscricao` | [VAL-AJU-04: Conferir Item de Ajuste](./validacao/ajustes/f-conferir-item-ajuste.md) | Validação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| [`PDTIC25093-68`](../analise-impacto/AIM-PDTIC25093-68.md) · `HU-018_Analisar_Validar_Inscricao` | [VAL-ANA-01: Detalhar Inscrição](./validacao/analise-decisao/f-detalhar-inscricao.md) | Validação | ✏️ Rascunho | 📋 | 7 | — | Detalhar Inscrição | — |
| `HU-018_Analisar_Validar_Inscricao` | [VAL-ANA-02: Iniciar Validação](./validacao/analise-decisao/f-iniciar-validacao.md) | Validação | ✏️ Rascunho | 📋 | 3 | — | Iniciar Validação da Inscrição | — |
| `HU-018_Analisar_Validar_Inscricao` | [VAL-ANA-03: Aprovar Inscrição](./validacao/analise-decisao/f-aprovar-inscricao.md) | Validação | ✏️ Rascunho | 📋 | 6 | — | Aceitar / Rejeitar Inscrição | — |
| `HU-018_Analisar_Validar_Inscricao` | [VAL-ANA-04: Rejeitar Inscrição](./validacao/analise-decisao/f-rejeitar-inscricao.md) | Validação | ✏️ Rascunho | 📋 | — | — | Aceitar / Rejeitar Inscrição *(compartilhado)* | — |
| [`PDTIC25093-68`](../analise-impacto/AIM-PDTIC25093-68.md) | [VAL-ANA-05: Editar Inscrição Validada](./validacao/analise-decisao/f-editar-inscricao-validada.md) | Validação | ✏️ Rascunho | 📋 | 6 | — | Editar Inscrição Validada | — |
| — | [VAL-ANA-06: Excluir Inscrição Validada](./validacao/analise-decisao/f-excluir-inscricao-validada.md) | Validação | ✏️ Rascunho | 📋 | — | — | — *(a contar ⚠️)* | — |
| [`PDTIC25093-56`](../analise-impacto/AIM-PDTIC25093-56.md) · `HU-017_Listar_Inscricoes_Validacao` | [VAL-FIL-01: Pesquisar Inscrições para Validação](./validacao/fila-validacao/f-pesquisar-inscricao.md) | Validação | ✏️ Rascunho | 📋 | 7 | — | Consultar Dashboard Validação de Inscrições | — |
| [`PDTIC25093-58`](../analise-impacto/AIM-PDTIC25093-58.md) · `HU-023_Dashboard_Gerencial_Validacao` | [VAL-FIL-02: Acompanhar Painel de Validação](./validacao/fila-validacao/f-acompanhar-painel-validacao.md) | Validação | ✏️ Rascunho | 📋 | 7 | — | Consultar Dashboard Gerencial | — |
| [`PDTIC25093-58`](../analise-impacto/AIM-PDTIC25093-58.md) | [VAL-FIL-03: Exportar Histórico do Painel de Validação](./validacao/fila-validacao/f-exportar-historico-painel.md) | Validação | ✏️ Rascunho | 📋 | 7 | — | Exportar Histórico do Painel de Validação | — |

<!-- História: chave do ServiceNow que originou a feature (seção "Origem" do N3). Uma feature pode ter mais de uma história e vice-versa. PF/CFP: preencher após PROMPT_3B (critérios em global/SIZING.md). Totais vigentes excluem features ❌ Deprecadas. Gates desta tabela: `audit-trace-links.mjs` prova o elo história↔feature nos três lugares (## Origem do N3 + ## Rastreabilidade da história + esta linha); `suspect-links.mjs --mark` marca ⚠️ Revisão necessária quando o outro lado do elo muda. -->

**Total vigente: 607 PF · — CFP** *(487 PF do baseline APF `PIEL_BASELINE_PF_CD.xlsx` atribuídos por feature, mais 77 PF de 12 processos elementares contados em 2026-09-01, 14 PF de 2 processos elementares contados em 2026-10-02 e 29 PF de 5 processos elementares contados em 2026-10-04 sobre os N3 — essas capacidades não existiam quando o baseline foi levantado; CFP não medido)*

> ⚠️ **Nem toda feature criada fora do baseline soma PF.** Elas nasceram da conferência com o código, não do baseline — que foi levantado em 2026-02-28, antes de essas capacidades existirem. Em **2026-09-01** foram contadas as **11 alcançadas pela SP05** — `AVL-APU-01`, `AVL-APU-02`, `AVL-APU-03`, `AVL-APU-05`, `AVL-APU-08`, `AVL-APU-09`, `AVL-APU-10` (2 PE), `AVL-APU-12`, `AVL-PAI-04`, `VAL-ANA-05` e `VAL-FIL-03` —, que somam **77 PF** em 12 processos elementares e já aparecem na coluna PF acima. ⚠️ Essa contagem está **pendente de validação pela equipe de métricas**. Em **2026-10-02** foram contadas as **2 pedidas por `PDTIC25093-65`** — `AVL-ALO-05` — Consultar Panorama do Avaliador e `AVL-ALO-07` — Exportar Relatório de Alocação —, que somam **14 PF** e também já aparecem na coluna PF acima, igualmente ⚠️ **pendentes de validação**. Em **2026-10-04** foram contadas as **2 features que a Sprint 6 entregou** — `AVL-APU-13` — Desclassificar Inscrição na Etapa (2 processos elementares, 12 PF) e `AVL-APU-14` — Enviar Feedback ao Participante (3 processos elementares, 17 PF) —, somando **29 PF**, também ⚠️ **pendentes de validação**. As demais seguem sem número: `ACS-ACE-03` — Vincular Usuário ao Sistema, `AVL-ALO-06` — Consultar Pendências de Alocação, `AVL-AVA-06` — Consultar Outros Avaliadores, `AVL-AVA-07` — Consultar Premiações do Avaliador, `CFG-PRE-13` — Carregar Imagem de Configuração, `INS-PAR-08` — Registrar Pré-cadastro, `VAL-AJU-04` — Conferir Item de Ajuste e `VAL-ANA-06` — Excluir Inscrição Validada — mais as features cujo processo elementar legitimamente não existe (LOGON, passo dentro de outra feature, PE compartilhado), listadas em `global/SIZING.md`.

> A coluna **Processo elementar (APF)** traz o nome do PE como consta na planilha de contagem — `(+N)` indica que N outros PEs foram absorvidos pela mesma feature. A conciliação completa, com os critérios e as lacunas, está em `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*. Dos 607 PF aqui somados, **487 vêm do baseline**, **77 da contagem de 2026-09-01**, **14 da de 2026-10-02** e **29 da de 2026-10-04**; os 43 PF restantes dos 530 PF de transações do baseline pertencem a 9 combos e 3 PEs sem feature, listados naquela seção. Total do baseline: 647 PF (coluna PFB) — a coluna *PF Fábrica de Software* da planilha foi descartada pela equipe de métricas como falha de preenchimento (2026-08-28).

---

<!-- GATES:INICIO -->
## Esteira de checkpoints (gates)

> ⚙️ **Seção gerada por `scripts/gates.py` — não editar à mão.** Espelha o estado de cada feature na esteira (CP1 requisitos (PO/Negócio) → CP2 modelo-dados (DBA/Arquiteto)). Reflete o estado em **2026-10-04**.

| Feature | Origem | Estado | Situação |
|---|---|---|---|
| `CFG-PRE-01` ([spec](./configuracao/premios/f-pesquisar-premio.md)) | HU-001_Gerenciar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-04` ([spec](./configuracao/premios/f-ativar-inativar-premio.md)) | HU-001_Gerenciar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-02` ([spec](./configuracao/premios/f-cadastrar-premio.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-03` ([spec](./configuracao/premios/f-editar-premio.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-07` ([spec](./configuracao/premios/f-gerar-link-publico.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-08` ([spec](./configuracao/premios/f-consultar-link-publico.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-09` ([spec](./configuracao/premios/f-cadastrar-termo-aceite.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-10` ([spec](./configuracao/premios/f-editar-termo-aceite.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-11` ([spec](./configuracao/premios/f-excluir-termo-aceite.md)) | HU-002_Cadastrar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-05` ([spec](./configuracao/premios/f-exportar-premio.md)) | HU-003_Exportar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-06` ([spec](./configuracao/premios/f-importar-premio.md)) | HU-003_Exportar_Premios | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-CAT-01` ([spec](./configuracao/categorias/f-pesquisar-categoria.md)) | HU-004_Cadastrar_Categorias | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-CAT-02` ([spec](./configuracao/categorias/f-cadastrar-categoria.md)) | HU-004_Cadastrar_Categorias | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-CAT-03` ([spec](./configuracao/categorias/f-editar-categoria.md)) | HU-004_Cadastrar_Categorias | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-CAT-04` ([spec](./configuracao/categorias/f-visualizar-categoria.md)) | HU-004_Cadastrar_Categorias | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-CAT-05` ([spec](./configuracao/categorias/f-ativar-inativar-categoria.md)) | HU-004_Cadastrar_Categorias | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-MOD-01` ([spec](./configuracao/modalidades/f-pesquisar-modalidade.md)) | HU-005_Cadastrar_Modalidades | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-MOD-02` ([spec](./configuracao/modalidades/f-cadastrar-modalidade.md)) | HU-005_Cadastrar_Modalidades | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-MOD-03` ([spec](./configuracao/modalidades/f-editar-modalidade.md)) | HU-005_Cadastrar_Modalidades | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-MOD-04` ([spec](./configuracao/modalidades/f-visualizar-modalidade.md)) | HU-005_Cadastrar_Modalidades | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-MOD-05` ([spec](./configuracao/modalidades/f-ativar-inativar-modalidade.md)) | HU-005_Cadastrar_Modalidades | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-01` ([spec](./configuracao/tipos-participante/f-pesquisar-tipo-participante.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-02` ([spec](./configuracao/tipos-participante/f-cadastrar-tipo-participante.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-03` ([spec](./configuracao/tipos-participante/f-editar-tipo-participante.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-04` ([spec](./configuracao/tipos-participante/f-visualizar-tipo-participante.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-05` ([spec](./configuracao/tipos-participante/f-ativar-inativar-tipo-participante.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-15` ([spec](./configuracao/tipos-participante/f-configurar-equipe.md)) | HU-006_Cadastrar_Tipo_Participantes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-06` ([spec](./configuracao/tipos-participante/f-configurar-formulario.md)) | HU-007_Configurar_Formulario_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-07` ([spec](./configuracao/tipos-participante/f-cadastrar-campo.md)) | HU-007_Configurar_Formulario_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-08` ([spec](./configuracao/tipos-participante/f-editar-campo.md)) | HU-007_Configurar_Formulario_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-09` ([spec](./configuracao/tipos-participante/f-excluir-campo.md)) | HU-007_Configurar_Formulario_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-10` ([spec](./configuracao/tipos-participante/f-cadastrar-enquadramento.md)) | HU-008_Enquadramento_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-11` ([spec](./configuracao/tipos-participante/f-ativar-inativar-enquadramento.md)) | HU-008_Enquadramento_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-12` ([spec](./configuracao/tipos-participante/f-configurar-anexo.md)) | HU-009_Anexo_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-13` ([spec](./configuracao/tipos-participante/f-cadastrar-questao.md)) | HU-010_Questoes_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-14` ([spec](./configuracao/tipos-participante/f-editar-questao.md)) | HU-010_Questoes_Tipo_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-01` ([spec](./configuracao/ofertas/f-consultar-estrutura-premiacao.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-02` ([spec](./configuracao/ofertas/f-vincular-categoria.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-03` ([spec](./configuracao/ofertas/f-desvincular-categoria.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-04` ([spec](./configuracao/ofertas/f-vincular-modalidade.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-05` ([spec](./configuracao/ofertas/f-desvincular-modalidade.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-06` ([spec](./configuracao/ofertas/f-vincular-tipo-participante.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-07` ([spec](./configuracao/ofertas/f-desvincular-tipo-participante.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-08` ([spec](./configuracao/ofertas/f-duplicar-oferta.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-09` ([spec](./configuracao/ofertas/f-cadastrar-submodalidade.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-10` ([spec](./configuracao/ofertas/f-editar-submodalidade.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-VIN-11` ([spec](./configuracao/ofertas/f-ativar-inativar-submodalidade.md)) | HU-011_Vincular_Categoria_Modalidade_TipoParticipante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-LIS-01` ([spec](./configuracao/listas-sistema/f-pesquisar-lista.md)) | HU-012_Listas_do_Sistema | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-LIS-02` ([spec](./configuracao/listas-sistema/f-cadastrar-lista.md)) | HU-012_Listas_do_Sistema | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-LIS-03` ([spec](./configuracao/listas-sistema/f-editar-lista.md)) | HU-012_Listas_do_Sistema | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-LIS-04` ([spec](./configuracao/listas-sistema/f-excluir-lista.md)) | HU-012_Listas_do_Sistema | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-LIS-05` ([spec](./configuracao/listas-sistema/f-configurar-itens-lista.md)) | HU-012_Listas_do_Sistema | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-01` ([spec](./inscricao/inscricao-participante/f-cadastrar-inscricao.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-02` ([spec](./inscricao/inscricao-participante/f-editar-inscricao.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-03` ([spec](./inscricao/inscricao-participante/f-finalizar-inscricao.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-04` ([spec](./inscricao/inscricao-participante/f-reenviar-inscricao.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-05` ([spec](./inscricao/inscricao-participante/f-anexar-documento.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-06` ([spec](./inscricao/inscricao-participante/f-aceitar-termo.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-07` ([spec](./inscricao/inscricao-participante/f-retomar-inscricao.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-PAR-08` ([spec](./inscricao/inscricao-participante/f-registrar-pre-cadastro.md)) | HU-015_Inscricao_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-ACO-01` ([spec](./inscricao/acompanhamento/f-acompanhar-inscricao.md)) | HU-016_Dashboard_Participante | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-FIL-01` ([spec](./validacao/fila-validacao/f-pesquisar-inscricao.md)) | HU-017_Listar_Inscricoes_Validacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-AJU-04` ([spec](./validacao/ajustes/f-conferir-item-ajuste.md)) | HU-018_Analisar_Validar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-01` ([spec](./validacao/analise-decisao/f-detalhar-inscricao.md)) | HU-018_Analisar_Validar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-02` ([spec](./validacao/analise-decisao/f-iniciar-validacao.md)) | HU-018_Analisar_Validar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-03` ([spec](./validacao/analise-decisao/f-aprovar-inscricao.md)) | HU-018_Analisar_Validar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-04` ([spec](./validacao/analise-decisao/f-rejeitar-inscricao.md)) | HU-018_Analisar_Validar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-AJU-01` ([spec](./validacao/ajustes/f-solicitar-ajuste.md)) | HU-019_Solicitar_Ajustes_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ADM-01` ([spec](./acesso/administradores-regionais/f-pesquisar-administrador.md)) | HU-020_Cadastrar_Admin_Regionais | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ADM-02` ([spec](./acesso/administradores-regionais/f-cadastrar-administrador-regional.md)) | HU-020_Cadastrar_Admin_Regionais | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ADM-03` ([spec](./acesso/administradores-regionais/f-editar-administrador-regional.md)) | HU-020_Cadastrar_Admin_Regionais | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ADM-04` ([spec](./acesso/administradores-regionais/f-vincular-uf-administrador.md)) | HU-020_Cadastrar_Admin_Regionais | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-EMA-01` ([spec](./configuracao/modelos-email/f-consultar-modelo-email.md)) | HU-021_Configurar_Templates_Email | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-EMA-02` ([spec](./configuracao/modelos-email/f-editar-modelo-email.md)) | HU-021_Configurar_Templates_Email | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-EMA-03` ([spec](./configuracao/modelos-email/f-visualizar-email.md)) | HU-021_Configurar_Templates_Email | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-NOT-01` ([spec](./inscricao/notificacoes/f-consultar-notificacao.md)) | HU-022_Notificacoes_InApp | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-NOT-02` ([spec](./inscricao/notificacoes/f-marcar-notificacao-lida.md)) | HU-022_Notificacoes_InApp | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-FIL-02` ([spec](./validacao/fila-validacao/f-acompanhar-painel-validacao.md)) | HU-023_Dashboard_Gerencial_Validacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-01` ([spec](./avaliacao/etapas-configuracao/f-configurar-avaliacao.md)) | HU-024_Configurar_Etapas_de_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-02` ([spec](./avaliacao/etapas-configuracao/f-cadastrar-etapa.md)) | HU-024_Configurar_Etapas_de_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-03` ([spec](./avaliacao/etapas-configuracao/f-editar-etapa.md)) | HU-024_Configurar_Etapas_de_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-04` ([spec](./avaliacao/etapas-configuracao/f-excluir-etapa.md)) | HU-024_Configurar_Etapas_de_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-05` ([spec](./avaliacao/etapas-configuracao/f-reordenar-etapa.md)) | HU-024_Configurar_Etapas_de_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-01` ([spec](./avaliacao/alocacao/f-consultar-alocacao-avaliadores.md)) | HU-025_Alocar_Avaliadores | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-02` ([spec](./avaliacao/alocacao/f-alocar-avaliador-grupo.md)) | HU-025_Alocar_Avaliadores | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-03` ([spec](./avaliacao/alocacao/f-cadastrar-avaliador.md)) | HU-025_Alocar_Avaliadores | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-04` ([spec](./avaliacao/alocacao/f-alocar-avaliador-inscricao.md)) | HU-025_Alocar_Avaliadores | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-05` ([spec](./avaliacao/avaliacao-projetos/f-reabrir-avaliacao.md)) | HU-025_Alocar_Avaliadores | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-AJU-02` ([spec](./validacao/ajustes/f-consultar-auditoria-ajustes.md)) | HU-026_Auditoria_Ajustes_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-AJU-03` ([spec](./validacao/ajustes/f-exportar-auditoria-ajustes.md)) | HU-026_Auditoria_Ajustes_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-PAI-01` ([spec](./avaliacao/painel-administrativo/f-acompanhar-painel-avaliacoes.md)) | HU-027_Painel_Administrativo_Avaliacoes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-PAI-02` ([spec](./avaliacao/painel-administrativo/f-consultar-avaliacoes-etapa.md)) | HU-027_Painel_Administrativo_Avaliacoes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-PAI-03` ([spec](./avaliacao/painel-administrativo/f-consolidar-avaliacao.md)) | HU-027_Painel_Administrativo_Avaliacoes | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-03` ([spec](./avaliacao/avaliacao-projetos/f-avaliar-inscricao.md)) | HU-028_Avaliar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-04` ([spec](./avaliacao/avaliacao-projetos/f-finalizar-avaliacao.md)) | HU-028_Avaliar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-06` ([spec](./avaliacao/avaliacao-projetos/f-consultar-outros-avaliadores.md)) | HU-028_Avaliar_Inscricao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-02` ([spec](./avaliacao/avaliacao-projetos/f-aceitar-termo-confidencialidade.md)) | HU-029_Termo_Confidencialidade_Avaliador | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-07` ([spec](./avaliacao/avaliacao-projetos/f-consultar-premiacoes-avaliador.md)) | HU-029_Termo_Confidencialidade_Avaliador | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-07` ([spec](./avaliacao/etapas-configuracao/f-configurar-termo-confidencialidade.md)) | HU-029_Termo_Confidencialidade_Avaliador | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-12` ([spec](./avaliacao/apuracao-devolutiva/f-reabrir-etapa-uf.md)) | HU-030_Fechar_Etapa_Avaliacao | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-04` ([spec](./avaliacao/apuracao-devolutiva/f-gerar-devolutiva-ia.md)) | HU-031_Consolidar_Feedback | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-05` ([spec](./avaliacao/apuracao-devolutiva/f-revisar-devolutiva.md)) | HU-031_Consolidar_Feedback | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `INS-ACO-02` ([spec](./inscricao/acompanhamento/f-visualizar-devolutiva.md)) | HU-031_Consolidar_Feedback | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ETA-06` ([spec](./avaliacao/etapas-configuracao/f-configurar-criterios-desempate.md)) | HU-032_Configurar_Criterios_de_Desempate | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-AVA-01` ([spec](./avaliacao/avaliacao-projetos/f-acompanhar-minhas-avaliacoes.md)) | HU-033_Painel_Avaliacao_Avaliador | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-06` ([spec](./avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes-paradas.md)) | HU-037_Relatorio_Inscricoes_Em_Andamento | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-01` ([spec](./avaliacao/apuracao-devolutiva/f-apurar-resultado-etapa.md)) | PDTIC25093-49 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-02` ([spec](./avaliacao/apuracao-devolutiva/f-registrar-desempate.md)) | PDTIC25093-49 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-03` ([spec](./avaliacao/apuracao-devolutiva/f-encerrar-etapa-uf.md)) | PDTIC25093-49 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-09` ([spec](./avaliacao/apuracao-devolutiva/f-exportar-relatorio-etapa.md)) | PDTIC25093-49 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-10` ([spec](./avaliacao/apuracao-devolutiva/f-gerar-relatorio-inscricoes.md)) | PDTIC25093-56 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-FIL-03` ([spec](./validacao/fila-validacao/f-exportar-historico-painel.md)) | PDTIC25093-58 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-05` ([spec](./avaliacao/alocacao/f-consultar-panorama-avaliador.md)) | PDTIC25093-65 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-07` ([spec](./avaliacao/alocacao/f-exportar-relatorio-alocacao.md)) | PDTIC25093-65 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-08` ([spec](./avaliacao/apuracao-devolutiva/f-consultar-ranking-etapa.md)) | PDTIC25093-66 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-05` ([spec](./validacao/analise-decisao/f-editar-inscricao-validada.md)) | PDTIC25093-68 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-14` ([spec](./avaliacao/apuracao-devolutiva/f-enviar-feedback-participante.md)) | PDTIC25093-69 | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ACE-01` ([spec](./acesso/acesso-perfis/f-autenticar-usuario.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ACE-02` ([spec](./acesso/acesso-perfis/f-consultar-perfil-usuario.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-ACE-03` ([spec](./acesso/acesso-perfis/f-vincular-usuario-sistema.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `ACS-AUD-01` ([spec](./acesso/auditoria/f-consultar-trilha-auditoria.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-ALO-06` ([spec](./avaliacao/alocacao/f-consultar-pendencias-alocacao.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-APU-13` ([spec](./avaliacao/apuracao-devolutiva/f-desclassificar-inscricao-etapa.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `AVL-PAI-04` ([spec](./avaliacao/painel-administrativo/f-exportar-relatorio-avaliadores.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-12` ([spec](./configuracao/premios/f-configurar-criterios-avaliacao.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-PRE-13` ([spec](./configuracao/premios/f-carregar-imagem-configuracao.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `CFG-TIP-16` ([spec](./configuracao/tipos-participante/f-importar-configuracao.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |
| `VAL-ANA-06` ([spec](./validacao/analise-decisao/f-excluir-inscricao-validada.md)) | — | ✏️ rascunho | aguardando **requisitos** (PO/Negócio) |

**0** de **128** feature(s) prontas para desenvolvimento.
<!-- GATES:FIM -->

---

<!-- PENDENCIAS:INICIO -->
## Pendências de especificação

> ⚙️ **Seção gerada pelo PROMPT_PENDENCIAS (PD) — não editar à mão.**
> Varre as fontes (AIMs em `analise-impacto/`, READMEs de N2, N3 com ⚠️) e espelha aqui o que está
> **pendente de especificar**. Edições manuais entre os marcadores são sobrescritas na
> próxima execução. Reflete o estado em **[AAAA-MM-DD]** — rode o **PD** para atualizar.

### Existência (falta N3)

> Algo é conhecido como necessário mas ainda **não tem N3**. Resolva pela rota indicada.

| Item | Nível | Origem | Rota |
|---|---|---|---|
| [Cancelar pedido] | N3 | [`STRYxxxxxxx`](../analise-impacto/AIM-[CHAVE].md) · N2 [Feature Set] | 3A |

### Conteúdo (⚠️ em aberto)

> O artefato **existe**, mas tem lacunas/suposições aguardando esclarecimento.

| Feature | Lacuna | Arquivo |
|---|---|---|
| [Nome da feature] | [pergunta em aberto, ex.: idade mínima exigida?] | [arquivo.md](./[dominio]/[feature-set]/[feature].md) |
<!-- PENDENCIAS:FIM -->

---

## Entidades consolidadas

> Entidades principais (ALIs) por domínio. Lista completa das 59 entidades em `global/DATA-MODEL.md`.

| Entidade | Domínio | N1 de origem |
|---|---|---|
| Premiação | Configuração da Premiação | [configuracao/README.md](./configuracao/README.md) |
| Categoria | Configuração da Premiação | [configuracao/README.md](./configuracao/README.md) |
| Modalidade | Configuração da Premiação | [configuracao/README.md](./configuracao/README.md) |
| Tipo de Participante | Configuração da Premiação | [configuracao/README.md](./configuracao/README.md) |
| Listas do Sistema | Configuração da Premiação | [configuracao/README.md](./configuracao/README.md) |
| Inscrição | Inscrição | [inscricao/README.md](./inscricao/README.md) |
| Notificação Participante | Inscrição | [inscricao/README.md](./inscricao/README.md) |
| Validação de Inscrição | Validação | [validacao/README.md](./validacao/README.md) |
| Auditoria de E-mail | Validação | [validacao/README.md](./validacao/README.md) |
| Avaliação de Inscrição | Avaliação | [avaliacao/README.md](./avaliacao/README.md) |
| Alocação de Avaliadores | Avaliação | [avaliacao/README.md](./avaliacao/README.md) |
| Usuário (vínculo por UF) | Acesso e Gestão | [acesso/README.md](./acesso/README.md) |

---

## Eventos do sistema

> ⚠️ O sistema não usa barramento de eventos identificado no schema — as integrações entre domínios são por **leitura/escrita direta** (ver mapa abaixo). Confirmar se há eventos/notificações assíncronas no código.

| Evento | Publicado por | Consumido por | Payload principal |
|---|---|---|---|
| — | — | — | — |

---

## Mapa de integrações entre domínios

| Domínio origem | Depende de | Tipo | Descrição |
|---|---|---|---|
| Inscrição | Configuração da Premiação | Leitura | Oferta, formulário dinâmico, anexos exigidos e termos da edição |
| Validação | Inscrição | Leitura/Escrita | Lê inscrições enviadas; altera o status (aprovar/rejeitar/solicitar ajuste) |
| Validação | Configuração da Premiação | Leitura | Estrutura e termos conferidos na validação |
| Validação | Acesso e Gestão | Leitura | Vínculo do administrador às UFs (escopo) |
| Avaliação | Inscrição | Leitura/Escrita | Lê inscrições validadas; reflete aprovação por etapa e devolutiva |
| Avaliação | Configuração da Premiação | Leitura | Questionário, critérios de avaliação e etapas |
| Todos | Acesso e Gestão | Leitura/Escrita | Perfil e escopo regional do usuário; ações críticas geram auditoria |

---

## Legenda de status

Estados da **esteira de checkpoints**, derivados dos `gates` no front-matter de cada N3. A próxima etapa só ocorre após a aprovação da anterior — ordem: requisitos → modelo-dados → testes → código.

| Ícone | Estado | Checkpoint | Descrição |
|---|---|---|---|
| ✏️ | rascunho | — | N3 em elaboração, nenhum gate aprovado |
| 📝 | requisitos-aprovados | CP1 (PO) | Requisitos validados — aguardando modelo de dados |
| 🧱 | modelo-validado | CP2 (DBA) | Modelo físico de dados validado — aguardando testes |
| 📋 | especificado | CP3 (QA) | **Pronto para desenvolvimento** (CP1+CP2+CP3 aprovados) |
| 🔄 | em-desenvolvimento | — | Implementação em andamento (estado manual) |
| ✅ | implementado | CP4 (code review) | Em produção, rastreabilidade preenchida |
| ⚠️ | revisao-necessaria | — | Spec e código (ou spec e ticket) divergem — a spec mudou depois da implementação, o código mudou sem a spec, ou o outro lado de um elo mudou (estado manual; o `suspect-links` também o marca) |
| ❌ | deprecado | — | Feature removida do sistema |
