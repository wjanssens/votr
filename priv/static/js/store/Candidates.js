Ext.define('Votr.store.Candidates', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Candidate',
    data: [
        { name: { default: 'Tarsier' }, description: { default: 'Tarsiiformes Party' }, withdrawn: false, votes: 5, status: 'excluded', round: 3 },
        { name: { default: 'Gorilla' }, description: { default: 'Simian Party' }, withdrawn: false, votes: 28, surplus: 2, status: 'elected', round: 2 },
        { name: { default: 'Monkey' },  description: { default: 'Simian Party' }, withdrawn: false, votes: 33, surplus: 7, status: 'elected', round: 1 },
        { name: { default: 'Tiger' },   description: { default: 'Pantherinae Party' }, withdrawn: false, votes: 34, surplus: 8, status: 'elected', round: 5 },
        { name: { default: 'Lynx' },    description: { default: 'Felinae Party' }, withdrawn: false, votes: 13, status: 'excluded', round: 4 }
    ]
});
