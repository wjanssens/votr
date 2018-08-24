Ext.define('Votr.model.User', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'username', type: 'string'},
        {name: 'password', type: 'string'},
        {name: 'name', type: 'string'},
        {name: 'email', type: 'string'},
        {name: 'phone', type: 'string'},
        {name: 'challenge', type: 'string'},
        {name: 'response', type: 'string'}
    ]
});
