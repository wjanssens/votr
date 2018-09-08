Ext.define('Votr.store.Results', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.Result',
    data: [
        { name: 'Monkey', round: 1, votes: 33, surplus: 7, status: 'elected'},
        { name: 'Gorilla', round: 2, votes: 28, surplus: 2, status: 'elected'},
        { name: 'Tarsier', round: 3, votes: 5, status: 'excluded'},
        { name: 'Lynx', round: 4, votes: 13, status: 'excluded'},
        { name: 'Tiger', round: 5, votes: 34, surplus: 8, status: 'elected'}
    ]
});
