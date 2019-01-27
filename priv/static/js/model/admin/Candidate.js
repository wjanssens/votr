Ext.define('Votr.model.admin.Candidate', {
    extend: 'Ext.data.Model',
    fields: [
        {name: 'ward_id', type: 'integer'},
        {name: 'version', type: 'integer'},
        {name: 'ext_id', type: 'string'},
        {name: 'seq', type: 'integer'},
        {name: 'names' },
        {name: 'descriptions' },
        {name: 'withdrawn', type: 'boolean'},
        {name: 'color', type: 'string'},
        {name: 'votes', type: 'number'},
        {name: 'round', type: 'number'},
        {name: 'status', type: 'string'},
        {name: 'percentage', type: 'number'},
        {
            name: 'text', type: 'string', depends: ['names'], calculate: function (data) {
                return data.names == null ? '' : data.names.default;
            }
        }
    ]
});
