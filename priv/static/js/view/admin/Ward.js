Ext.define('Votr.view.admin.Ward', {
    extend: 'Ext.form.Panel',
    alias: 'widget.admin.ward',
    bind: {
        disabled: '{!wardList.selection}'
    },
    layout: 'vbox',
    defaults: {
        margin: 0
    },
    items: [
        {
            layout: 'hbox',
            defaults: {
                margin: 10,
                flex: 1
            },
            items: [
                { flex: 1 },
                {
                    width: 300,
                    layout: "hbox",
                    items: [
                        { html: "<i class='fa fa-globe'></i>", style: "font-size: 3.5em;", padding: "0 16px" },
                        {
                            layout: "vbox",
                            items: [
                                { cls: "stat", bind: { html: '<a href="#wards/{wardList.selection.id}">{wardList.selection.ward_ct}</a>' } },
                                { html: "wards".translate(), cls: "p" }
                            ]
                        }
                    ]
                },
                {
                    width: 300,
                    layout: "hbox",
                    items: [
                        { html: "<i class='fa fa-check-square-o'></i>", style: "font-size: 3.5em;", padding: "0 16px" },
                        {
                            layout: "vbox",
                            items: [
                                { cls: "stat", bind: { html: '<a href="#ballots/{wardList.selection.id}">{wardList.selection.ballot_ct}</a>' } },
                                { html: "ballots".translate(), cls: "p" }
                            ]
                        }
                    ]
                },
                {
                    width: 300,
                    layout: "hbox",
                    items: [
                        { html: "<i class='fa fa-user-o'></i>", style: "font-size: 3.5em;", padding: "0 16px" },
                        {
                            layout: "vbox",
                            items: [
                                { cls: "stat", bind: { html: '<a href="#voters/{wardList.selection.id}">{wardList.selection.voter_ct}</a>' } },
                                { html: "voters".translate(), cls: "p" }
                            ]
                        }
                    ]
                },
                { flex: 1 }
            ]
        },
        {
            layout: 'vbox',
            items: [
                {
                    layout: 'hbox',
                    padding: 0,
                    items: [{
                        xtype: 'textfield',
                        name: 'name',
                        label: 'Name'.translate(),
                        flex: 1,
                        bind: {
                            value: '{name}',
                            placeHolder: '{wardList.selection.names.default}'
                        }
                    }, {
                        xtype: 'selectfield',
                        label: 'Language'.translate(),
                        width: 128,
                        bind: {
                            store: '{languages}',
                            value: '{language}'
                        }
                    }]
                }, {
                    layout: 'hbox',
                    padding: 0,
                    items: [{
                        xtype: 'textfield',
                        name: 'description',
                        label: 'Description'.translate(),
                        flex: 1,
                        bind: {
                            value: '{description}',
                            placeHolder: '{wardList.selection.descriptions.default}'
                        }
                    }, {
                        xtype: 'selectfield',
                        label: 'Language'.translate(),
                        width: 128,
                        bind: {
                            store: '{languages}',
                            value: '{language}'
                        }
                    }]
                }, {
                   xtype: 'selectfield',
                   name: 'type',
                   label: 'Type'.translate(),
                   bind: '{wardList.selection.type}',
                   options: [{
                       text: 'Election'.translate(),
                       value: 'election'
                   }, {
                       text: 'Poll'.translate(),
                       value: 'poll'
                   }, {
                       text: 'Count'.translate(),
                       value: 'count'
                   }]
               }, {
                    xtype: 'textfield',
                    name: 'ext_id',
                    label: 'External ID'.translate(),
                    bind: '{wardList.selection.ext_id}'
                }, {
                    xtype: 'textfield',
                    name: 'start_at',
                    label: 'Start At'.translate(),
                    placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
                    bind: '{wardList.selection.start_at}'
                }, {
                    xtype: 'textfield',
                    name: 'end_at',
                    label: 'End At'.translate(),
                    placeHolder: 'yyyy-mm-dd hh:mm [±hh:mm]',
                    bind: '{wardList.selection.end_at}'
                }, {
                    xtype: 'textfield',
                    name: 'updated_at',
                    label: 'Updated At'.translate(),
                    readOnly: true,
                    bind: '{wardList.selection.updated_at}'
                }
            ]
        }
    ]
});
