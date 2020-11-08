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
db.aluno.insert({
    nome: 'José da Silva', 
    sexo: 'Masculino'})
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
//update com novo campo na certificacao
db.certificacao.update(
    {nome: /network associate/i },
    {$set: {carga_horaria: 270, empresa: 'CISCO'} }
) 
db.certificacao.find()
//consulta com and - mais de um criterio de busca
db.aluno.find(
    {nome_completo: /tos/i, sexo: /masc/i }
)
db.aluno.find({
    nome_completo: /tos/i, 
    sexo: /masc/i, 
    sobrenome: /tos/i, 
    sexo: /masc/i})
//consulta com or
db.aluno.find({
    $or:[
        {nome_completo: /tos/i}, 
        {nome: /do/i},
        {sobrenome: /do/i},
        {sexo: /masc/i}]
})
//consulta com or e and
db.aluno.find({
    $or:[
        {nome_completo: /tos/i}, 
        {nome: /do/i},
        {sobrenome: /do/i}
]},
        {sexo:{$not:  /masc/i}} 
)
db.aluno.find()
//procurar no inicio da string
db.aluno.find({
    $or:[
        {nome_completo: /^jo/i}, 
        {nome: /^jo/i},
        {primeiro_nome: /^jo/i}]
})
//procurar no final da string
db.aluno.find({
    $or:[
        {nome_completo: /silva$/i}, 
        {nome: /silva$/i},
        {primeiro_nome: /silva$/i}]
})
//operadores de comparação numérica: gt = greater than lt = lower than gte = maior ou igual lte = menor ou igual
//certificacoes com menos de 280 horas
db.certificacao.find()
db.certificacao.find({carga_horaria:  {$lt: 280}} )
//Carga menor ou igual a 280
db.certificacao.find({carga_horaria:  {$lte: 200}} )
//Com nota de corte superior a 75
db.certificacao.find({nota_corte: {$gt: 75}})
db.certificacao.find({nota_corte: {$gte: 75}})
//removendo um doc especifico ou todos que atendem ao critério
db.aluno.insert({nome_completo: 'Neymar Junior', sexo: 'Masculino'})
db.aluno.insert({nome_completo: 'Waldemar Soares', sexo: 'Masculino'})
db.aluno.find({nome_completo: /mar/i})
db.aluno.remove({nome_completo: /mar/i})
//True remove só a primeira ocorriencia
db.aluno.remove({nome_completo: /mar/i}, true)
//Adicionando um novo campo para todos os documentos = aggregate
db.aluno.find()
db.aluno.aggregate([
   { $addFields: {nacionalidade: ''} }
])
//Atualizando somente a primeira ocorrencia
db.aluno.updateOne(
    {sexo:/masc/i},
    {$set: {nacionalidade: 'Brasil'}})
//Atualizando todas as ocorrencias    
db.aluno.updateMany(
    {sexo:/masc/i},
    {$set: {nacionalidade: 'Brasil'}})   
//Atualizando os telefones
//fones para maria
db.aluno.updateOne(
    {primeiro_nome: /^Maria/i}, 
    {$set:{fones:[2222,4444,6666]} }
)
db.aluno.find({nome_completo: /mar/i})
//novo telefone para maria - cria um novo vetor dentro do fone, nao dá certo
db.aluno.updateOne(
    {primeiro_nome: /^Maria/i},
    {$push: {fones: [8888]}}
)
db.aluno.find()
//para dar certo tem que usar o operador $each
db.aluno.updateOne(
    {primeiro_nome: /^Maria/i},
    {$push: {fones: {$each:[8888]}}}
)
//atualizando um numero especifico
db.aluno.find({fones: 4444})
//atualizando 4444
db.aluno.updateOne(
    {primeiro_nome: /^Maria/i, fones: 4444},
    {$set: {"fones.$": 9999}}
)
