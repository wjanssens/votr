Ext.define('Votr.model.ResultRound', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'round', type: 'integer'},
        {name: 'threshold', type: 'number'},
        {name: 'candidates'}
    ]
});
