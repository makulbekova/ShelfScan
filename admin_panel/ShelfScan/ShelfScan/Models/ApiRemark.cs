using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_remark")]
[Index("ScanId", Name = "api_remark_scan_id_38f9984d")]
public partial class ApiRemark
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("remark")]
    public string Remark { get; set; } = null!;

    [Column("scan_id")]
    public long ScanId { get; set; }

    [ForeignKey("ScanId")]
    [InverseProperty("ApiRemarks")]
    public virtual ApiScan Scan { get; set; } = null!;
}
