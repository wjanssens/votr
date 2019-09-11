Ext.define('Votr.view.index.Stats', {
    extend: 'Ext.Container',
    alias: 'widget.index.stats',
    layout: 'hbox',
    defaults: {
        padding: 8
    },
    items: [
        { flex: 1 },
        {
            layout: "hbox",
            items: [
                { html: "<i class='fa fa-globe'></i>", style: "font-size: 4em;", padding: "0 16px" },
                {
                    layout: "vbox",
                    items: [
                        { html: "12 345", cls: "stat", itemId: "votes_cast_yesterday" },
                        { html: "votes cast<br/>yesterday", cls: "p" }
                    ]
                }
            ]
        },
        {
            layout: "hbox",
            items: [
                { html: "<i class='fa fa-globe'></i>", style: "font-size: 4em;", padding: "0 16px" },
                {
                    layout: "vbox",
                    items: [
                        { html: "12 345", cls: "stat", itemId: "votes_cast_last_7_days" },
                        { html: "votes cast<br/>last 7 days", cls: "p" }
                    ]
                }
            ]
        },

        {
            layout: "hbox",
            items: [
                { html: "<i class='fa fa-check-square-o'></i>", style: "font-size: 4em;", padding: "0 16px" },
                {
                    layout: "vbox",
                    items: [
                        { html: "12 345", cls: "stat", itemId: "ballots_open" },
                        { html: "ballots<br/>open", cls: "p" }
                    ]
                }
            ]
        },
        {
            layout: "hbox",
            items: [
                { html: "<i class='fa fa-check-square-o'></i>", style: "font-size: 4em;", padding: "0 16px" },
                {
                    layout: "vbox",
                    items: [
                        { html: "12 345", cls: "stat", itemId: "ballots_all_time" },
                        { html: "ballots<br/>all time", cls: "p" }
                    ]
                }
            ]
        },

        { flex: 1 }
    ]
});
