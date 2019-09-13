Ext.define('Votr.model.admin.Ballot', {
    extend: 'Ext.data.Model',
    requires: [
        'Votr.data.field.DateTime'
    ],
    fields: [
        {name: 'version', type: 'int', critical: true},
        {name: 'ward_id', type: 'string'},
        {name: 'ext_id', type: 'string'},
        {name: 'seq', type: 'int'},
        {name: 'titles'},
        {name: 'descriptions'},
        {name: 'method', type: 'string'},
        {name: 'quota', type: 'string'},
        {name: 'electing', type: 'integer'},
        {name: 'color', type: 'string'},
        {name: 'shuffle', type: 'boolean'},
        {name: 'mutable', type: 'boolean'},
        {name: 'anonymous', type: 'boolean'},
        {name: 'public', type: 'boolean'},
        {name: 'candidate_ct', type: 'integer'},
        {name: 'round_ct', type: 'integer'},
        {name: 'updated_at', type: 'datetime'}
    ],
    proxy: {
        type: 'rest',
        url: '../api/admin/ballots',
        reader: { type: 'json', rootProperty: 'ballots' }
    }
});
