Ext.define('Votr.model.admin.ResultCandidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'name', type: 'string'},
        {name: 'status', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'surplus', type: 'number'},
        {name: 'received', type: 'number'},
        {name: 'exhausted', type: 'number'},
        {
            name: 'temp', type: 'number', depends: ['votes', 'received'], calculate: function (data) {
                return data.votes - data.received;
            }
        }
    ]
});
