use certificacoes
show collections
db.aluno.insert({
    nome:'João da Silva', 
    sexo:'Masculino', 
    fones:[
        12345,6789    
    ]
})

db.aluno.find()

db.aluno.insert([{
    primeiro_nome: 'Maria',
    sobrenome: 'Cardoso',
    cpf: 4875633,
    endereco: 'Rua Frei João, 100-Ipiranga-SP'
},
{
    nome_completo: 'Givanildo dos Santos',
    rg: '49148559-1',
    sexo: 'Masculino',
}])

db.aluno.find({cpf:4875633})
db.aluno.find({cpf: {$ne: 4875633} })
db.aluno.find({sexo: 'Masculino'})
db.aluno.find({sexo: {$regex: /masc/i}  })
db.aluno.find({sexo: /masc/i})
db.certificacao.drop() //remove uma colecao inteira
db.certificacao.remove({}) //remove só os documentos
db.aluno.insert({nome: 'José da Silva', sexo: 'Masculino'})
db.aluno.find()
db.aluno.remove({nome: /jose/i})
db.certificacao.insert({
    id: 'OCA',
    nome:'Oracle Certified Associate',
    carga_horaria: 200
})
db.certificacao.insert([{
    id: 'CCNA',
    nome: 'Cisco Certified Associate',
    prazo_conclusao: 180
},
{
    id: 'SAPA',
    nome: 'SAPA Associate',
    carga_horaria: 200,
    nota_corte: 75,
    empresa: 'SAP'
}])
db.certificacao.update(//update novo campo na certificacao
    {nome: /network associate/i },
    {$set: {carga_horaria: 270, empresa: 'CISCO'} }
) 
db.certificacao.find()