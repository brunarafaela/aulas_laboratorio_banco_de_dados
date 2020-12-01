/*exemplar (Num_exemplar(PK), ISBN(PFK), Num_edicao, Idioma_exemplar, Ano_publicacao, Qtde_pags, Tipo_exemplar, Tipo_midia, Vl_exemplar, Prazo_devolucao, Tipo_aquisicao, Situacao_exemplar, Cod_editora(FK))
obra (ISBN(PK), Titulo_original, Idioma_original, Genero, Classificacao)
autor(Cod_autor(PK), Nome_autor, Nacionalidade_autor)*/


use bibioteca
show collections

//1- Crie uma coleção para obra e coloque os exemplares dentro dela. Insira 2 obras cada uma com 2 exemplares. Coloque os campos que julgar necessário.
db.obra.remove ({})
db.obra.insert([
  {isbn: 9788576055648,
  titulo_original: 'Computer Organization and Architecture',
  idioma_original: 'Inglês',
  genero: 'Informática',
  classficacao: 'Livre',
  exemplar: [
    {
        num_exemplar: 001,
        isbn: 9788576055648, 
        num_edicao: 10,
        idioma_exemplar: 'Português',
        ano_publicacao: ISODate("2017-09-15T11:30:00.000Z") , 
        qtd_pags: 864, 
        tipo_exemplar: 'Didático', 
        tipo_midia: 'Física',
        vl_exemplar: 163.34, 
        prazo_devolucao: '7 dias',
        tipo_aquisicao: 'Doação',
        situacao_exemplar: 'Usado',
        cod_editora: 001, 
    },
    {
        num_exemplar: 002,
        isbn: 9788576055648, 
        num_edicao: 10,
        idioma_exemplar: 'Português',
        ano_publicacao: ISODate("2017-09-15T11:30:00.000Z") , 
        qtd_pags: 864, 
        tipo_exemplar: 'Didático', 
        tipo_midia: 'Física',
        vl_exemplar: 163.34, 
        prazo_devolucao: '7 dias',
        tipo_aquisicao: 'Compra',
        situacao_exemplar: 'Novo',
        cod_editora: 001, 
    }
    ]
  },
   {isbn: 9788575594155,
  titulo_original: 'Das Kapital',
  idioma_original: 'Alemão',
  genero: 'Economia política',
  classficacao: 'Livre',
  exemplar: [
    {
        num_exemplar: 003,
        isbn: 9788576055648, 
        num_edicao: 1,
        idioma_exemplar: 'Português',
        ano_publicacao: ISODate("2014-01-01T11:30:00.000Z") , 
        qtd_pags: 864, 
        tipo_exemplar: 'Didático', 
        tipo_midia: 'Física',
        vl_exemplar: 95.90, 
        prazo_devolucao: '7 dias',
        tipo_aquisicao: 'Doação',
        situacao_exemplar: 'Usado',
        cod_editora: 002, 
    },
    {
        num_exemplar: 004,
        isbn: 9788576055648, 
        num_edicao: 1,
        idioma_exemplar: 'Inglês',
        ano_publicacao: ISODate("2014-01-01T11:30:00.000Z"), 
        qtd_pags: 864, 
        tipo_exemplar: 'Didático', 
        tipo_midia: 'Física',
        vl_exemplar: 95.90, 
        prazo_devolucao: '7 dias',
        tipo_aquisicao: 'Compra',
        situacao_exemplar: 'Usado',
        cod_editora: 002, 
    }
    ]
  }
])
db.obra.find({})

//2- Crie uma outra coleção agora para autores. Coloque os campos que julgar necessário e insira 3 autores.
db.autor.remove ({})
db.autor.insert([
  {
    cod_autor: 001,
    nome_autor: 'William Stallings',
    nacionalidade_autor: 'Estadunidense'
  },
  {
    cod_autor: 002,
    nome_autor: 'Andrew Stuart Tanenbaum',
    nacionalidade_autor: 'Estadunidense'
  }, 
  {
    cod_autor: 003,
    nome_autor: 'Karl Marx',
    nacionalidade_autor: 'Alemã'
  }
])
db.autor.find ({})

//3- Atualize a coleção obra para conter os autores.
db.obra.aggregate([
   { $addFields: {cod_autor: ''} }
])

db.obra.updateOne(
    {titulo_original:/architecture/i},
    {$set: {cod_autor: 001}})

db.obra.updateOne(
    {titulo_original:/kapital/i},
    {$set: {cod_autor: 003}})
    
db.obra.find ({})
    
//Consultas
//a. Quais obras tem exemplares com mais de 2 edições. Mostre o título da obra.
db.obra.aggregate (
    {$match: {"num_edicao": { $gt : 2 } }},
    { $lookup :
       { from: "exemplar",
        localField : "isbn.exemplar",
        foreignField : "exemplar" ,
        as : "obra_com_exemplar" }
    },
    {$unwind: "$obra_com_exemplar"},
    {$project : { _id:0, titulo_original:1} 
    }
)

//b. Quais obras tem exemplares no idioma Inglês. Mostre o título da obra.
db.obra.aggregate (
    { $lookup :
       { from: "exemplar",
        localField : "isbn.exemplar",
        foreignField : "exemplar" ,
        as : "obra_com_exemplar" }
    },
    {$unwind: "$obra_com_exemplar"},
    {$match: {"obra_com_exemplar.idioma_exemplar": /ing/i }},
    {$project : { _id:0, "titulo_original":1} 
    }
)

//c. Qual o nome do(s) autor(es) de cada obra. Mostre o título e o nome do autor.
db.obra.aggregate (
    { $lookup :
       { from: "autor",
        localField : "cod_autor.autor",
        foreignField : "obra" ,
        as : "obra_com_autor" }
    },
    {$unwind: "$obra_com_autor"},
    {$project : { _id:0, "titulo_original":1, "obra_com_autor.nome_autor": 1} 
    }
)
