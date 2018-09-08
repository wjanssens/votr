Ext.define('Votr.store.Candidates', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Candidate',
    data: [
        { name: 'Tarsier', description: 'Tarsiiformes Party', withdrawn: false, votes: 5, status: 'excluded', round: 3 },
        { name: 'Gorilla', description: 'Simian Party', withdrawn: false, votes: 28, surplus: 2, status: 'elected', round: 2 },
        { name: 'Monkey', description: 'Simian Party', withdrawn: false, votes: 33, surplus: 7, status: 'elected', round: 1 },
        { name: 'Tiger', description: 'Pantherinae Party', withdrawn: false, votes: 34, surplus: 8, status: 'elected', round: 5 },
        { name: 'Lynx', description: 'Felinae Party', withdrawn: false, votes: 13, status: 'excluded', round: 4 }
    ]
});
