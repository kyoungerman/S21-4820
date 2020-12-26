package q8stype

type UpdateDataRow struct {
	URL   string `json:"url"`
	ID10s string `json:"id10"`
	ID10n int    `json:"-"`
	ID60  string `json:"id60"`
	Data  string `json:"data"`
}

type UpdateData struct {
	Data []UpdateDataRow
}

type AuthType struct {
	Status    string `json:"status"`
	AuthToken string `json:"auth_token"`
	UserID    string `json:"user_id"`
}

// {
// 	"status": "success",
// 	"data": "test=5",
// 	"to": "http://www.2c-why.com?test=5\u0026base10=4911\u0026base10=4911\u0026base60=AABRF\u0026hasdata=yes"
// }
type DecType struct {
	Status string `json:"status"`
	Data   string `json:"data"`
	To     string `json:"to"`
}
