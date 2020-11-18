use sus

//CREATES + INSERTS

//PACIENTE
db.paciente.insert([
    {
    numero_SUS: 12345,
    nome_paciente:'VALTER GARCIA', 
    end_paciente: {logradouro : 'AVENIDA', nome: 'AMALIA FRANCO', numero: 100, bairro: 'MOOCA', cidade:'São Paulo', estado: 'São Paulo', uf: 'SP', cep: '04193020'},
    sexo_paciente: 'M',
    dt_nascto_pac: ISODate("1949-02-20T16:30:00.000Z"),
    cpf_paciente: '12358411878',
    responsavel: 'Proprio',
    cpf_respo: '12358411878',
    email_paciente: 'vgarcia@gmail.com',
    fones_paciente:[
        11945004500,
        23312332333   
    ],
    atendimentos: [{
        num_atendimento: 1123456,
        data_hora_atendimento: ISODate("2020-11-10T16:30:00.000Z"),
        cod_atendimento: 124,
        situacao_atendimento: 'Concluido',
        cod_unidade: 18,  //referenciando a unidade
        motivo_atendimento: 'Aplicação de vacina', 
        recursos_minimos: 'Vacina e agulhas', 
        funcionario:[{
            reg_func: '100',
            nome_func: 'GILDA CAMPOS MACHADO',
            end_func: 'AV SALIM FARAH MALUF 988',
            sexo_func: 'F',
            dt_nascto_func: ISODate("1975-11-22T16:30:00.000Z"),
            fone_func: '1145772311',
            email_func: 'gcmachado@terra.com.br', 
            cargo: 'Auxiliar de Enfermagem',
            dt_admissao: ISODate("2010-01-12T16:30:00.000Z"),
            dt_final_contrato:'ISODate("2030-01-12T16:30:00.000Z")',
            tipo_contrato: 'EFETIVO',
            cod_unidade: 18,
        }],
        tipos_atendimentos: {
            cod_tipo_atendimento: 1, 
            cod_vacina: 1, //referenciando  a vacina
            tipo_atendimento: 'Vacinacao', 
            dose_numero: 1,
            data_dose_anterior: '', 
            recursos_minimos: '', 
            proxima_dose: '',
            dt_proxima_dose: '', 
            dt_hora_notifica_proxima: '',
            cod_vacina: 1,
        }
    }]
    },
    {
     numero_SUS: 12345,
    nome_paciente:'MARIA LUCIEIDE', 
    end_paciente: {logradouro : 'AVENIDA', nome: 'SARAH VELOSO', numero: 645, bairro: 'Pirutuba', cidade:'São Paulo', estado: 'São Paulo', uf: 'SP', cep: '04193040'},
    sexo_paciente: 'F',
    dt_nascto_pac: ISODate("1975-10-15T16:30:00.000Z"),
    cpf_paciente: '2117958498',
    responsavel: 'Proprio',
    cpf_respo: '2117958498',
    email_paciente: 'mluc@uol.com.br',
    fones_paciente:[
        945004500,
        2331233255 
    ],
        atendimentos: [{
        cod_atendimento: 135,
        data_hora_atendimento: ISODate("2020-07-10T16:30:00.000Z"),
        cod_unidade: 19,  //referenciando a unidade
        motivo_atendimento: 'Consulta de rotina para resultado de exames feitos previamente', 
        recursos_minimos: '', 
        funcionario:[{
            reg_func: '101',
            nome_func: 'DIRCE CRUZ DE SOUZA',
            end_func: 'AV DO CURSINO 415',
            sexo_func: 'F',
            dt_nascto_func: ISODate("1972-05-20T16:30:00.000Z"),
            fone_func: '1137895778',
            email_func: 'dircecruz211@uol.com.br', 
            cargo: 'Enfermeira',
            dt_admissao: ISODate("2019-08-30T16:30:00.000Z"),
            dt_final_contrato:'ISODate("2021-08-30T16:30:00.000Z")',
            tipo_contrato: 'TEMPORARIO',
            cod_unidade: 19,
        }],
        tipos_atendimentos: {
            cod_tipo: 2, 
            diagnostico_inicial: 'Consulta de rotina',  
            cod_atendimento: 123, 
            tipo_atendimento: 'Consulta', 
            prescricao_med: '',
            observacoes: 'Consulta de rotina', 
            recursos_minimos:'' , 
        }  
    }]
    },
])

db.paciente.find()

//VACINA
db.vacina.insert([{
    cod_vacina: 1, 
    nome_vacina:'Febre Amarela', 
    nome_cientifico:'Flavivirus', 
    forma_aplicacao: 'Por injeção via subcutânea (sob a pele) na parte superior do braço - músculo deltóide',
    numero_doses: 1, 
    intervalo_doses_meses: 'Reforco a cada 10 anos', 
    imunizacao: 'Proteção contra a febre amarela, doença infecciosa, causada por um vírus transmitido por vários tipos de mosquito', 
    contra_indicacoes: 'Nao existe',
    grupos_risco_indicacoes: 'Nao há', 
    faixa_etaria_inicial: 0.5, 
    dose_recomendada_inicial: '5ml', 
    faixa_etaria_final: '100', 
    dose_recomendada_final: '5ml' , 
    condicoes_armazenamento: 'Entre 5 C e 10 C' , 
    estoque_minimo: 100, 
    estoque_disponivel: 3219 , 
    lote_atual:  '123SP',
    lote_vacina:[
    {
         numero_lote: '123SP' , 
         data_aquisicao: ISODate("2020-11-15T16:30:00.000Z"),
         quantidade: 5000,
         data_validade: ISODate("2022-11-15T16:30:00.000Z"),
         fabricante: 'Pfizer',
         origem: 'EUA'
     }
    ],
    lote_vacina:[
    {
         numero_lote: '456SP' , 
         data_aquisicao: ISODate("2018-12-15T16:30:00.000Z"),
         quantidade: 9000,
         data_validade: ISODate("2020-12-15T16:30:00.000Z"),
         fabricante: 'Pfizer',
         origem: 'EUA'
     }
    ]
}, {
     cod_vacina: 2, 
    nome_vacina:'Gripe', 
    nome_cientifico:'Influenza', 
    forma_aplicacao: 'Por injeção via subcutânea (sob a pele) na parte superior do braço - músculo deltóide',
    numero_doses: 1, 
    intervalo_doses_meses: 'Todo ano', 
    imunizacao: 'Proteção contra a influenza ou gripe', 
    contra_indicacoes: 'Nao existe',
    grupos_risco_indicacoes: 'Nao há', 
    faixa_etaria_inicial: 60, 
    dose_recomendada_inicial: '2ml', 
    faixa_etaria_final: '100', 
    dose_recomendada_final: '2ml' , 
    condicoes_armazenamento: 'Entre 5 C e 10 C' , 
    estoque_minimo: 500, 
    estoque_disponivel: 8189 , 
    lote_atual:  '789BR20',
    lote_vacina:[
    {
         numero_lote: '789BR20' , 
         data_aquisicao: ISODate("2019-10-15T16:30:00.000Z") ,
         quantidade: 5000,
         data_validade: ISODate("2021-10-15T16:30:00.000Z"),
         fabricante: 'Instituto Butantan',
         origem: 'BRASIL'
     }
    ]
}
])

db.vacina.find()


//UNIDADE DE SAUDE
db.unidade_saude.insert([
    {
    cod_unidade: 18, 
    nome_unidade:'AMA UBS Integrada Sao Vicente de Paula',
    end_unidade: {logradouro : 'RUA', nome: 'Vicente da Costa', numero: 289, cidade:'São Paulo', estado: 'São Paulo', uf: 'SP', cep: '04266-050'},
    fone_unidade:[
        1120637354,1142638354    
    ],
    regiao: 'SUL',
    distrito: 'IPIRANGA',
    Tipo_unidade: 'UBS', 
    leitos_UTI: 0, 
    leitos_emergencia:  10,
    respo_unidade: '', 
},
{
   cod_unidade: 19, 
    nome_unidade: 'Hospital do Servidor Publico Municipal',
    end_unidade: {logradouro : 'RUA', nome: 'Castro Alves', numero: 60, cidade:'São Paulo', estado: 'São Paulo', uf: 'SP', cep: '01532-001'},
    fone_unidade:[
        1133977700,1193846495    
    ],
    regiao: 'CENTRO',
    distrito: 'LIBERDADE',
    Tipo_unidade: 'HOSPITAL', 
    leitos_UTI: 30, 
    leitos_emergencia: 80,
    respo_unidade: '',   
}
])

db.unidade_saude.find()

//SELECTS

//9i
//Mostre o nome, logradouro, bairro e cidade, e número dos telefones para os pacientes com menos de 60 anos cujo final de telefone seja número par
db.paciente.find(
    {
        //pacientes com menos de 60 anos  - pelo amor de deus eu nao achei NADA na internet sobre trabalhar com datas, descobrir a idade etc sos
        //dt_nascto_pac:{$lt: 60}, 
        fones_paciente: { $mod: [2,0] }
    },
    {
        numero_SUS: 0,
        sexo_paciente: 0,
        cpf_paciente: 0,
        responsavel: 0,
        cpf_respo: 0,
        email_paciente: 0,
        atendimentos: 0,
        dt_nascto_pac: 0,
        "end_paciente.estado": 0,
        "end_paciente.uf": 0,
        "end_paciente.cep": 0,
    }
)


//9iii
//Mostre todos os dados da carteira de vacinação de pacientes que tomaram a vacina contra febre amarela nos últimos dois anos
db.paciente.aggregate(
    {$lookup: {
          from: "unidade_saude",
          localField: "atendimentos.cod_unidade",
          foreignField: "cod_unidade",
          as: "atendimentos_realizados"
         },
    },
     {$lookup: {
           from: "vacina",
           localField: "atendimentos.tipos_atendimentos.cod_vacina",
           foreignField: "cod_vacina",
           as: "vacinas_realizadas"
         }
    },
//   {$match: { "atendimentos.data_hora_atendimento": {gt: 2} }, nos últimos dois anos
    {$match: { "vacinas_realizadas.nome_vacina": /amar/i }},
    {$unwind: "$atendimentos_realizados"},
    {$unwind: "$vacinas_realizadas"},
    {$project: { _id:0, numero_SUS: 1, nome_paciente: 1, sexo_paciente: 1, dt_nascto_pac: 1, cpf_paciente: 1,
            "atendimentos.num_atendimento": 1,
            "atendimentos.data_hora_atendimento": 1,
            "atendimentos_realizados.nome_unidade": 1,
            "atendimentos_realizados.fone_unidade":1,
            "atendimentos_realizados.regiao": 1,
            "atendimentos_realizados.distrito": 1,
            "vacinas_realizadas.cod_vacina": 1, 
            "vacinas_realizadas.nome_vacina": 1, 
     }}
)
    
    
//6iii
//Mostre a lista dos atendimentos diários de uma determinada Unidade de Saúde
db.paciente.aggregate(
    {$lookup: {
           from: "unidade_saude",
           localField: "atendimentos.cod_unidade",
           foreignField: "cod_unidade",
           as: "atendimentos_realizados"
         }
    },
     {$unwind: "$atendimentos_realizados"},
    {$project: { _id:0, numero_SUS: 0, end_paciente: 0, dt_nascto_pac:0, cpf_paciente: 0, cpf_respo: 0,
            "atendimentos.cod_atendimento": 0, 
            "atendimentos.situacao_atendimento": 0, 
            "atendimentos.motivo_atendimento": 0,
            "atendimentos.recursos_minimos": 0,
            "atendimentos.reg_func": 0,
            "atendimentos.tipos_atendimentos.cod_vacina": 0, 
            "atendimentos.tipos_atendimentos.dose_numero": 0, 
            "atendimentos.tipos_atendimentos.data_dose_anterior": 0,  
            "atendimentos.tipos_atendimentos.recursos_minimos": 0, 
            "atendimentos.tipos_atendimentos.proxima_dose": 0, 
            "atendimentos.tipos_atendimentos.dt_proxima_dose": 0, 
            "atendimentos.tipos_atendimentos.dt_hora_notifica_proxima": 0, 
            "atendimentos.tipos_atendimentos.cod_vacina": 0,
     }}
)

//6x
//Mostre os funcionários da área de enfermagem (Enfermeiro, Auxiliar de Enfermagem, etc.) que nunca aplicaram vacina 
//Nome Funcionário - Cargo- Data Admissão - Tempo de Trabalho (quantidade em anos que trabalha na Unidade de saúde).

db.paciente.find(
    { "atendimentos.tipos_atendimentos.tipo_atendimento": {$not: /vac/i}, "atendimentos.funcionario.cargo": /enf/i },
  
    {   
            "atendimentos.tipos_atendimentos.tipo_atendimento": 1, 
            "atendimentos.funcionario.nome_func": 1,
            "atendimentos.funcionario.cargo": 1,
            "atendimentos.funcionario.dt_admissao": 1,
            //tempo de trabalho -  - pelo amor de deus eu nao achei NADA na internet sobre trabalhar com datas, descobrir a idade etc sos
     }
)
    

//6viii
//Mostre os pacientes que realizam consultas mas não tomam vacina
db.paciente.find(
    {"atendimentos.tipos_atendimentos.tipo_atendimento": {$not: /vac/i} }
)