using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.EntityFrameworkCore;

namespace ShelfScan.Models;

[Table("api_scan")]
[Index("EmployeeId", Name = "api_scan_employee_id_f262cebe")]
[Index("LocationId", Name = "api_scan_location_id_32a4bd8e")]
[Index("PhotoId", Name = "api_scan_photo_id_aa56c3a4")]
public partial class ApiScan
{
    [Key]
    [Column("id")]
    public long Id { get; set; }

    [Column("scan_datetime")]
    public DateTime ScanDatetime { get; set; }

    [Column("employee_id")]
    public long EmployeeId { get; set; }

    [Column("location_id")]
    public long LocationId { get; set; }

    [Column("photo_id")]
    public long PhotoId { get; set; }

    [InverseProperty("Scan")]
    public virtual ICollection<ApiProduct> ApiProducts { get; set; } = new List<ApiProduct>();

    [InverseProperty("Scan")]
    public virtual ICollection<ApiRemark> ApiRemarks { get; set; } = new List<ApiRemark>();

    [ForeignKey("EmployeeId")]
    [InverseProperty("ApiScans")]
    public virtual ApiEmployee Employee { get; set; } = null!;

    [ForeignKey("LocationId")]
    [InverseProperty("ApiScans")]
    public virtual ApiLocation Location { get; set; } = null!;

    [ForeignKey("PhotoId")]
    [InverseProperty("ApiScans")]
    public virtual ApiPhoto Photo { get; set; } = null!;
}
