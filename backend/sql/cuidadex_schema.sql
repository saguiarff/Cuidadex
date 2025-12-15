-- =====================================================
-- CUIDADEX - SCRIPT DE BANCO DE DADOS
-- Banco: PostgreSQL
-- Descrição: Estrutura completa do sistema Cuidadex
-- Inclui:
--   - Tabelas
--   - Chaves primárias e estrangeiras
--   - Check constraints
--   - Triggers
--   - Functions / Procedures
--   - Views
--   - Índices
-- =====================================================


-- =====================================================
-- 1. TABELA DE USUÁRIOS
-- =====================================================
CREATE TABLE usuarios (
    id BIGSERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefone VARCHAR(20) NOT NULL,
    cpf CHAR(11) UNIQUE NOT NULL,
    data_nascimento DATE NOT NULL,
    senha_hash TEXT NOT NULL,
    tipo_usuario CHAR(1) NOT NULL CHECK (tipo_usuario IN ('C', 'G')), -- C = cliente, G = cuidador
    ativo BOOLEAN DEFAULT TRUE,
    data_cadastro TIMESTAMP DEFAULT NOW(),
    avatar_url TEXT
);


-- =====================================================
-- 2. CLIENTES E CUIDADORES
-- =====================================================
CREATE TABLE clientes (
    usuario_id BIGINT PRIMARY KEY REFERENCES usuarios(id),
    recebe_notificacoes BOOLEAN DEFAULT TRUE
);

CREATE TABLE cuidadores (
    usuario_id BIGINT PRIMARY KEY REFERENCES usuarios(id),
    bio TEXT,
    valor_hora DECIMAL(10,2) NOT NULL CHECK (valor_hora >= 20.00),
    raio_atendimento_km INT CHECK (raio_atendimento_km > 0 AND raio_atendimento_km <= 100),
    verificado BOOLEAN DEFAULT FALSE,
    nota_media DECIMAL(3,2) DEFAULT 0,
    total_avaliacoes INT DEFAULT 0,
    disponivel BOOLEAN DEFAULT TRUE
);


-- =====================================================
-- 3. TIPOS DE CUIDADO E RELACIONAMENTO
-- =====================================================
CREATE TABLE tipos_cuidado (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE cuidador_tipos_cuidado (
    cuidador_id BIGINT REFERENCES cuidadores(usuario_id),
    tipo_cuidado_id INT REFERENCES tipos_cuidado(id),
    experiencia_anos INT CHECK (experiencia_anos >= 0),
    certificado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (cuidador_id, tipo_cuidado_id)
);


-- =====================================================
-- 4. ENDEREÇOS
-- =====================================================
CREATE TABLE enderecos (
    id BIGSERIAL PRIMARY KEY,
    usuario_id BIGINT NOT NULL REFERENCES usuarios(id),
    cep CHAR(8) NOT NULL,
    logradouro VARCHAR(100) NOT NULL,
    numero VARCHAR(10),
    complemento VARCHAR(50),
    bairro VARCHAR(60) NOT NULL,
    cidade VARCHAR(60) NOT NULL,
    uf CHAR(2) NOT NULL,
    principal BOOLEAN DEFAULT FALSE,
    latitude DECIMAL(10,8),
    longitude DECIMAL(11,8)
);


-- =====================================================
-- 5. AGENDAMENTOS E AVALIAÇÕES
-- =====================================================
CREATE TABLE agendamentos (
    id BIGSERIAL PRIMARY KEY,
    cliente_id BIGINT NOT NULL REFERENCES clientes(usuario_id),
    cuidador_id BIGINT NOT NULL REFERENCES cuidadores(usuario_id),
    tipo_cuidado_id INT NOT NULL REFERENCES tipos_cuidado(id),
    data_inicio TIMESTAMP NOT NULL,
    data_fim TIMESTAMP NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pendente'
        CHECK (status IN ('pendente','confirmado','em_andamento','concluido','cancelado')),
    observacoes TEXT,
    criado_em TIMESTAMP DEFAULT NOW(),
    CONSTRAINT check_datas_validas CHECK (data_fim > data_inicio),
    CONSTRAINT check_valor_positivo CHECK (valor_total > 0)
);

CREATE TABLE avaliacoes (
    id BIGSERIAL PRIMARY KEY,
    agendamento_id BIGINT UNIQUE NOT NULL REFERENCES agendamentos(id),
    nota INT NOT NULL CHECK (nota BETWEEN 1 AND 5),
    comentario TEXT,
    data_avaliacao TIMESTAMP DEFAULT NOW()
);


-- =====================================================
-- 6. DOCUMENTOS DO CUIDADOR
-- =====================================================
CREATE TABLE documentos_cuidador (
    id BIGSERIAL PRIMARY KEY,
    cuidador_id BIGINT NOT NULL REFERENCES cuidadores(usuario_id),
    tipo_documento VARCHAR(50) NOT NULL,
    url_arquivo TEXT NOT NULL,
    validade DATE,
    aprovado BOOLEAN DEFAULT FALSE,
    data_upload TIMESTAMP DEFAULT NOW()
);


-- =====================================================
-- 7. TRIGGERS DE VALIDAÇÃO
-- =====================================================

-- Garante apenas um endereço principal por usuário
CREATE OR REPLACE FUNCTION trg_unica_principal_endereco()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.principal = TRUE THEN
        UPDATE enderecos
        SET principal = FALSE
        WHERE usuario_id = NEW.usuario_id
          AND id IS DISTINCT FROM NEW.id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER enderecos_unico_principal_trg
BEFORE INSERT OR UPDATE ON enderecos
FOR EACH ROW EXECUTE FUNCTION trg_unica_principal_endereco();


-- Garante que apenas usuários do tipo cliente possam entrar em clientes
CREATE OR REPLACE FUNCTION fn_check_tipo_usuario_cliente()
RETURNS TRIGGER AS $$
DECLARE v_tipo CHAR;
BEGIN
    SELECT tipo_usuario INTO v_tipo FROM usuarios WHERE id = NEW.usuario_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'usuario % não existe', NEW.usuario_id;
    END IF;
    IF v_tipo <> 'C' THEN
        RAISE EXCEPTION 'usuario % não é do tipo cliente (C)', NEW.usuario_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_tipo_cliente
BEFORE INSERT OR UPDATE ON clientes
FOR EACH ROW EXECUTE FUNCTION fn_check_tipo_usuario_cliente();


-- Garante que apenas usuários do tipo cuidador possam entrar em cuidadores
CREATE OR REPLACE FUNCTION fn_check_tipo_usuario_cuidador()
RETURNS TRIGGER AS $$
DECLARE v_tipo CHAR;
BEGIN
    SELECT tipo_usuario INTO v_tipo FROM usuarios WHERE id = NEW.usuario_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'usuario % não existe', NEW.usuario_id;
    END IF;
    IF v_tipo <> 'G' THEN
        RAISE EXCEPTION 'usuario % não é do tipo cuidador (G)', NEW.usuario_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_tipo_cuidador
BEFORE INSERT OR UPDATE ON cuidadores
FOR EACH ROW EXECUTE FUNCTION fn_check_tipo_usuario_cuidador();


-- =====================================================
-- 8. PROCEDURES E FUNÇÕES DE NEGÓCIO
-- =====================================================

-- Criar agendamento com validações
CREATE OR REPLACE FUNCTION sp_criar_agendamento(
    p_cliente_id BIGINT,
    p_cuidador_id BIGINT,
    p_tipo_cuidado_id INT,
    p_data_inicio TIMESTAMP,
    p_data_fim TIMESTAMP,
    p_valor_total DECIMAL(10,2),
    p_observacoes TEXT DEFAULT NULL
) RETURNS BIGINT AS $$
DECLARE
    v_overlaps INT;
    v_new_id BIGINT;
    v_disponivel BOOLEAN;
BEGIN
    IF p_data_fim <= p_data_inicio THEN
        RAISE EXCEPTION 'data_fim deve ser maior que data_inicio';
    END IF;

    SELECT disponivel INTO v_disponivel
    FROM cuidadores
    WHERE usuario_id = p_cuidador_id;

    IF NOT FOUND OR v_disponivel IS DISTINCT FROM TRUE THEN
        RAISE EXCEPTION 'cuidador % não disponível', p_cuidador_id;
    END IF;

    SELECT COUNT(*) INTO v_overlaps
    FROM agendamentos
    WHERE cuidador_id = p_cuidador_id
      AND status IN ('pendente','confirmado','em_andamento')
      AND NOT (p_data_fim <= data_inicio OR p_data_inicio >= data_fim);

    IF v_overlaps > 0 THEN
        RAISE EXCEPTION 'conflito de horário';
    END IF;

    INSERT INTO agendamentos
        (cliente_id, cuidador_id, tipo_cuidado_id, data_inicio, data_fim, valor_total, observacoes)
    VALUES
        (p_cliente_id, p_cuidador_id, p_tipo_cuidado_id, p_data_inicio, p_data_fim, p_valor_total, p_observacoes)
    RETURNING id INTO v_new_id;

    RETURN v_new_id;
END;
$$ LANGUAGE plpgsql;


-- Verificação administrativa do cuidador
CREATE OR REPLACE FUNCTION sp_set_verificacao_cuidador(
    p_cuidador_id BIGINT,
    p_aprovado BOOLEAN
) RETURNS VOID AS $$
BEGIN
    UPDATE cuidadores
    SET verificado = p_aprovado
    WHERE usuario_id = p_cuidador_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'cuidador % não encontrado', p_cuidador_id;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Inserir avaliação e recalcular média
CREATE OR REPLACE FUNCTION fn_inserir_avaliacao_e_recalcular(
    p_agendamento_id BIGINT,
    p_nota INT,
    p_comentario TEXT DEFAULT NULL
) RETURNS VOID AS $$
DECLARE
    v_cuidador_id BIGINT;
    v_total INT;
    v_soma INT;
BEGIN
    IF p_nota NOT BETWEEN 1 AND 5 THEN
        RAISE EXCEPTION 'nota inválida';
    END IF;

    SELECT cuidador_id INTO v_cuidador_id
    FROM agendamentos
    WHERE id = p_agendamento_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'agendamento não encontrado';
    END IF;

    INSERT INTO avaliacoes (agendamento_id, nota, comentario)
    VALUES (p_agendamento_id, p_nota, p_comentario);

    SELECT COUNT(*), COALESCE(SUM(a.nota),0)
    INTO v_total, v_soma
    FROM avaliacoes a
    JOIN agendamentos ag ON ag.id = a.agendamento_id
    WHERE ag.cuidador_id = v_cuidador_id;

    UPDATE cuidadores
    SET total_avaliacoes = v_total,
        nota_media = ROUND((v_soma::numeric / v_total)::numeric, 2)
    WHERE usuario_id = v_cuidador_id;
END;
$$ LANGUAGE plpgsql;


-- =====================================================
-- 9. VIEW E FUNÇÃO DE RELATÓRIO
-- =====================================================
CREATE OR REPLACE VIEW vw_agendamentos_relatorio AS
SELECT
    ag.id AS agendamento_id,
    ag.cliente_id,
    uc.nome AS cliente_nome,
    uc.email AS cliente_email,
    ag.cuidador_id,
    ud.nome AS cuidador_nome,
    tc.id AS tipo_cuidado_id,
    tc.nome AS tipo_cuidado_nome,
    ag.data_inicio,
    ag.data_fim,
    ag.valor_total,
    ag.status,
    av.nota AS nota_avaliacao,
    av.comentario AS comentario_avaliacao,
    av.data_avaliacao
FROM agendamentos ag
LEFT JOIN usuarios uc ON uc.id = ag.cliente_id
LEFT JOIN usuarios ud ON ud.id = ag.cuidador_id
LEFT JOIN tipos_cuidado tc ON tc.id = ag.tipo_cuidado_id
LEFT JOIN avaliacoes av ON av.agendamento_id = ag.id;


CREATE OR REPLACE FUNCTION fn_relatorio_por_cuidador(p_cuidador_id BIGINT)
RETURNS TABLE (
    agendamento_id BIGINT,
    cliente_id BIGINT,
    cliente_nome VARCHAR,
    cliente_email VARCHAR,
    cuidador_id BIGINT,
    cuidador_nome VARCHAR,
    tipo_cuidado_id INT,
    tipo_cuidado_nome VARCHAR,
    data_inicio TIMESTAMP,
    data_fim TIMESTAMP,
    valor_total DECIMAL,
    status VARCHAR,
    nota_avaliacao INT,
    comentario_avaliacao TEXT,
    data_avaliacao TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT *
    FROM vw_agendamentos_relatorio
    WHERE cuidador_id = p_cuidador_id
    ORDER BY data_inicio DESC;
END;
$$ LANGUAGE plpgsql;


-- =====================================================
-- 10. ÍNDICES
-- =====================================================
CREATE INDEX IF NOT EXISTS idx_agendamentos_cuidador_data
    ON agendamentos(cuidador_id, data_inicio);

CREATE INDEX IF NOT EXISTS idx_agendamentos_cliente_data
    ON agendamentos(cliente_id, data_inicio);

CREATE INDEX IF NOT EXISTS idx_cuidadores_verificado_nota
    ON cuidadores(verificado, nota_media);
