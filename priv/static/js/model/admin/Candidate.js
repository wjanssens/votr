Ext.define('Votr.model.admin.Candidate', {
    extend: 'Ext.data.Model',
    requires: [
        'Votr.data.field.DateTime'
    ],
    fields: [
        {name: 'version', type: 'integer', critical: true},
        {name: 'ballot_id', type: 'integer'},
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
        {name: 'updated_at', type: 'datetime'},
        {
            name: 'text', type: 'string', depends: ['names'], calculate: function (data) {
                return data.names == null ? '' : data.names.default;
            }
        }
    ],
    proxy: {
        type: 'rest',
        url: '../api/admin/candidates',
        reader: { type: 'json', rootProperty: 'candidates' }
    }
});
