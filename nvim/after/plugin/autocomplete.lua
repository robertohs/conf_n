local cmp = require("cmp")

local luasnip = require("luasnip")
--require("luasnip/loaders/from_vscode").lazy_load()

local lspkind = require("lspkind")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	performance = {
		debounce = 0,
		throttle = 0,
	},
	mapping = {
		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-y>"] = cmp.mapping(
			cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Insert,
				select = true,
			}),
			{ "i", "c" }
		),
		["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
		["<C-l>"] = cmp.mapping(function()
			if luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			end
		end),
		["<C-h>"] = cmp.mapping(function()
			if luasnip.jumpable(-1) then
				luasnip.jump(-1)
			end
		end),
	},
	formatting = {
		fields = { "kind", "abbr", "menu" },
		format = lspkind.cmp_format({
			mode = "symbol_text",
			maxwidth = 50,
			ellipsis_char = "...",
			show_labelDetails = true,

			before = function(entry, vim_item)
				vim_item.menu = ({
					nvim_lsp = "[LSP]",
					nvim_lua = "[NVIM LSP]",
					path = "[Path]",
				})[entry.source.name]
				return vim_item
			end,
		}),
	},
	preselect = cmp.PreselectMode.None,
	sorting = {
		priority_weight = 2,
		comparators = {
			cmp.config.compare.offset,
			cmp.config.compare.exact,
			cmp.config.compare.score,
			cmp.config.compare.kind,
			cmp.config.compare.recently_used,
			cmp.config.compare.locality,

			--Make entries that start with underline appear after
			function(entry1, entry2)
				local _, entry1_under = entry1.completion_item.label:find("^_+")
				local _, entry2_under = entry2.completion_item.label:find("^_+")
				entry1_under = entry1_under or 0
				entry2_under = entry2_under or 0
				if entry1_under > entry2_under then
					return false
				elseif entry1_under < entry2_under then
					return true
				end
			end,
		},
	},
	sources = cmp.config.sources({
		{ name = "nvim_lua" },
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer", keyword_length = 5 },
	}),
	window = {
		completion = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
		},
		documentation = {
			border = "rounded",
			winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None",
		},
	},
})
--local cmp_autopairs = require("nvim-autopairs.completion.cmp")
--cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
