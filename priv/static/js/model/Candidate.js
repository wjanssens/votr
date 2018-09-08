Ext.define('Votr.model.Candidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'name', type: 'string'},
        {name: 'description', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'withdrawn', type: 'boolean'},
        {name: 'color', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'round', type: 'number'},
        {name: 'status', type: 'string'},
        {name: 'percentage', type: 'number'}
    ]
});
