using System.Collections.Generic;
using System.Linq;
using HtmlAgilityPack;

namespace CP.Framework.Common.XSSManagement
{
    public static class HtmlSanitizer
    {
        private static readonly IDictionary<string, string[]> Whitelist;
        private static List<string> DeletableNodesXpath = new List<string>();

        static HtmlSanitizer()
        {
            Whitelist = new Dictionary<string, string[]> {
                { "a", new[] { "href" } },
                { "strong", null },
                { "em", null },
                { "blockquote", null },
                { "b", null},
                { "p", null},
                { "ul", null},
                { "ol", null},
                { "li", null},
                { "div", new[] { "align" } },
                { "strike", null},
                { "u", null},
                { "sub", null},
                { "sup", null},
                { "table", null },
                { "tr", null },
                { "td", null },
                { "th", null }
                };
        }

        public static string Sanitize(string input)
        {
            if (input.Trim().Length < 1)
                return string.Empty;
            var htmlDocument = new HtmlDocument();

            htmlDocument.LoadHtml(input);
            SanitizeNode(htmlDocument.DocumentNode);
            var xPath = HtmlSanitizer.CreateXPath();

            return StripHtml(htmlDocument.DocumentNode.WriteTo().Trim(), xPath);
        }

        private static void SanitizeChildren(HtmlNode parentNode)
        {
            for (int i = parentNode.ChildNodes.Count - 1; i >= 0; i--)
            {
                SanitizeNode(parentNode.ChildNodes[i]);
            }
        }

        private static void SanitizeNode(HtmlNode node)
        {
            if (node.NodeType == HtmlNodeType.Element)
            {
                if (!Whitelist.ContainsKey(node.Name))
                {
                    if (!DeletableNodesXpath.Contains(node.Name))
                    {
                         node.Name = "removeableNode";
                        DeletableNodesXpath.Add(node.Name);
                    }
                    if (node.HasChildNodes)
                    {
                        SanitizeChildren(node);
                    }

                    return;
                }

                if (node.HasAttributes)
                {
                    for (int i = node.Attributes.Count - 1; i >= 0; i--)
                    {
                        var currentAttribute = node.Attributes[i];
                        var allowedAttributes = Whitelist[node.Name];
                        if (allowedAttributes != null)
                        {
                            if (!allowedAttributes.Contains(currentAttribute.Name))
                            {
                                node.Attributes.Remove(currentAttribute);
                            }
                        }
                        else
                        {
                            node.Attributes.Remove(currentAttribute);
                        }
                    }
                }
            }

            if (node.HasChildNodes)
            {
                SanitizeChildren(node);
            }
        }

        private static string StripHtml(string html, string xPath)
        {
            var htmlDoc = new HtmlDocument();
            htmlDoc.LoadHtml(html);
            if (xPath.Length > 0)
            {
                var invalidNodes = htmlDoc.DocumentNode.SelectNodes(@xPath);
                foreach (HtmlNode node in invalidNodes)
                {
                    node.ParentNode.RemoveChild(node, true);
                }
            }
            return htmlDoc.DocumentNode.WriteContentTo();
        }

        private static string CreateXPath()
        {
            var _xPath = string.Empty;
            var builder = new System.Text.StringBuilder();
            builder.Append(_xPath);
            for (int i = 0; i < DeletableNodesXpath.Count; i++)
            {
                if (i != DeletableNodesXpath.Count - 1)
                {
                    builder.Append(string.Format("//{0}|", DeletableNodesXpath[i].ToString()));
                }
                else builder.Append(string.Format("//{0}|", DeletableNodesXpath[i].ToString()));
            }
            _xPath = builder.ToString();
            return _xPath;
        }
    }
}
