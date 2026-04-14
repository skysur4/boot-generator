package ${package}.common.entity;

import com.fasterxml.uuid.Generators;
import com.fasterxml.jackson.annotation.JsonFormat;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import ${package}.common.context.UserContext;

import java.time.LocalDateTime;
import java.util.UUID;


@Getter
@Setter
@MappedSuperclass
public abstract class BaseEntity {

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    @Column(name = "created_at", updatable = false)
    protected LocalDateTime createdAt;

    @Column(name = "created_by", updatable = false)
    protected String createdBy;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss.SSS")
    @Column(name = "updated_at")
    protected LocalDateTime updatedAt;

    @Column(name = "updated_by")
    protected String updatedBy;

    @PrePersist
    private void onInsertion(){
        this.createdAt = LocalDateTime.now();
        this.createdBy = UserContext.getId();
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = UserContext.getId();
    }

    @PreUpdate
    private void onModification(){
        this.updatedAt = LocalDateTime.now();
        this.updatedBy = UserContext.getId();
    }

}