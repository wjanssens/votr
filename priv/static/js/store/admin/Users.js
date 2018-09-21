Ext.define('Votr.store.admin.Users', {
    extend: 'Ext.data.Store',
    model: 'Votr.model.admin.User',
    data: [
        { name: 'User 1', voted: 0 },
        { name: 'User 2', voted: 0 },
        { name: 'User 3', voted: 0 },
        { name: 'User 4', voted: 0 }
    ]
});
