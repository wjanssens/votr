Ext.define('Votr.model.Candidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'name', type: 'string'},
        {name: 'desc', type: 'string'},
        {name: 'withdrawn', type: 'boolean'},
        {name: 'color', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'round', type: 'number'},
        {name: 'status', type: 'string'},
        {name: 'percentage', type: 'number'}
    ]
});
