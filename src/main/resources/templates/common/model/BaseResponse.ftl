package ${package}.common.model;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Getter;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * BASE Transporter DTO
 */
@Getter
public class BaseResponse implements Serializable {

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    protected LocalDateTime createdAt;

    protected String createdBy;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    protected LocalDateTime updatedAt;

    protected String updatedBy;

}