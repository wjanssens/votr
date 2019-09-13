Ext.define('Votr.model.admin.ResultRound', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'round', type: 'integer'},
        {name: 'threshold', type: 'number'},
        {name: 'candidates'}
    ]
});
