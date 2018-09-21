Ext.define('Votr.model.admin.Candidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'ext_id', type: 'string'},
        {name: 'name' },
        {name: 'description' },
        {name: 'withdrawn', type: 'boolean'},
        {name: 'color', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'round', type: 'number'},
        {name: 'status', type: 'string'},
        {name: 'percentage', type: 'number'}
    ]
});
