Ext.define('Votr.data.validator.DateTime', {
    extend: 'Ext.data.validator.Validator',
    alias: 'data.validator.datetime',

    type: 'datetime',

    config: {
        /**
         * @cfg {String} message
         * The error message to return.
         */
        message: 'Is in the wrong format'
    },

    constructor: function() {
        this.callParent(arguments);
    },

    validate: function(value) {
        if (value === null || value.length == 0) {
            return true;
        } else if (value !== null && value.length < 16) {
            return this.getMessage();
        } else if (value !== null && !Ext.isDate(value)) {
            const dt = Ext.Date.parse(value, 'c');
            return dt === null ? this.getMessage() : true;
        } else {
            return true;
        }
    }
});